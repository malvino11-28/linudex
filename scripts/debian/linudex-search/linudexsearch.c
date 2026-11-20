/*
 * LinuDex Search — XFCE panel plugin
 * XFCE 4.20 / GTK 3 search field with an independent, non-focus-stealing
 * popup window, because a GtkPopover inside an XFCE panel may not be visible.
 * GPL-3.0-or-later
 */
#include <gtk/gtk.h>
#include <gdk/gdkkeysyms.h>
#include <libxfce4panel/libxfce4panel.h>

typedef struct {
    XfcePanelPlugin *plugin;
    GtkWidget *entry;
    GtkWidget *placeholder;
    GtkWidget *popup;
    GtkWidget *scroll;
    GtkWidget *results;
    guint selected;
    guint result_count;
} SearchState;

static void hide_results (SearchState *state)
{
    gtk_widget_hide (state->popup);
}

static void launch_app (GAppInfo *app, SearchState *state)
{
    GError *error = NULL;
    if (!g_app_info_launch (app, NULL, NULL, &error)) {
        g_warning ("LinuDex Search: failed to launch %s: %s",
                   g_app_info_get_display_name (app), error->message);
        g_clear_error (&error);
    }
    hide_results (state);
    gtk_entry_set_text (GTK_ENTRY (state->entry), "");
}

static void row_clicked (GtkButton *button, gpointer user_data)
{
    SearchState *state = user_data;
    GAppInfo *app = g_object_get_data (G_OBJECT (button), "linudex-app");
    if (app != NULL)
        launch_app (app, state);
}

static gint compare_apps (gconstpointer a, gconstpointer b)
{
    return g_utf8_collate (g_app_info_get_display_name (G_APP_INFO ((gpointer) a)),
                           g_app_info_get_display_name (G_APP_INFO ((gpointer) b)));
}

static gboolean app_matches (GAppInfo *app, const gchar *needle)
{
    const gchar *name = g_app_info_get_display_name (app);
    const gchar *executable = g_app_info_get_executable (app);
    gchar *folded_name = g_utf8_casefold (name ? name : "", -1);
    gchar *folded_exec = g_utf8_casefold (executable ? executable : "", -1);
    gboolean match = g_strstr_len (folded_name, -1, needle) != NULL ||
                     g_strstr_len (folded_exec, -1, needle) != NULL;
    g_free (folded_name);
    g_free (folded_exec);
    return match;
}

static void highlight_row (SearchState *state)
{
    GList *children = gtk_container_get_children (GTK_CONTAINER (state->results));
    guint i = 0;
    for (GList *l = children; l != NULL; l = l->next, i++) {
        GtkStyleContext *css = gtk_widget_get_style_context (GTK_WIDGET (l->data));
        if (i < state->result_count && i == state->selected)
            gtk_style_context_add_class (css, "linudex-result-selected");
        else
            gtk_style_context_remove_class (css, "linudex-result-selected");
    }
    g_list_free (children);
}

/* Map the entry's local (0, 0) to screen coordinates and place the result
 * window directly above the single bottom XFCE panel. */
static void position_popup (SearchState *state, gint width, gint height)
{
    GtkWidget *toplevel = gtk_widget_get_toplevel (state->entry);
    GdkWindow *top_gdk_window = gtk_widget_get_window (toplevel);
    gint top_x = 0, top_y = 0;
    gint rel_x = 0, rel_y = 0;
    gint x, y;

    if (top_gdk_window == NULL ||
        !gtk_widget_translate_coordinates (state->entry, toplevel, 0, 0,
                                           &rel_x, &rel_y))
        return;

    gdk_window_get_origin (top_gdk_window, &top_x, &top_y);
    x = top_x + rel_x;
    y = top_y + rel_y - height - 4;

    GdkDisplay *display = gtk_widget_get_display (state->entry);
    GdkMonitor *monitor = gdk_display_get_monitor_at_point (display, x, top_y + rel_y);
    if (monitor != NULL) {
        GdkRectangle workarea;
        gdk_monitor_get_workarea (monitor, &workarea);
        x = CLAMP (x, workarea.x, MAX (workarea.x, workarea.x + workarea.width - width));
        if (y < workarea.y)
            y = top_y + rel_y + gtk_widget_get_allocated_height (state->entry) + 4;
        y = CLAMP (y, workarea.y,
                   MAX (workarea.y, workarea.y + workarea.height - height));
    }
    gtk_window_move (GTK_WINDOW (state->popup), x, y);
}

static void show_results (SearchState *state, guint rows)
{
    gint width = 354;
    gint height = MIN (328, MAX (48, (gint) rows * 42 + 12));

    gtk_widget_set_size_request (state->scroll, width, height);
    gtk_window_resize (GTK_WINDOW (state->popup), width, height);
    gtk_widget_show_all (state->scroll);
    position_popup (state, width, height);
    gtk_widget_show (state->popup);
    /* Reposition a mapped popup after sizing as well; no focus change. */
    position_popup (state, width, height);
}

/* Normalize icons to at most 24x24 pixels. Some .desktop entries (notably
 * file-backed icons) provide a very large intrinsic pixbuf and can otherwise
 * expand a result row beyond the intended size. */
static GdkPixbuf *load_app_icon (GIcon *icon)
{
    GdkPixbuf *pixbuf = NULL;
    GtkIconTheme *theme = gtk_icon_theme_get_default ();
    if (icon != NULL && G_IS_FILE_ICON (icon)) {
        GFile *file = g_file_icon_get_file (G_FILE_ICON (icon));
        gchar *path = g_file_get_path (file);
        if (path != NULL) {
            pixbuf = gdk_pixbuf_new_from_file_at_scale (path, 24, 24,
                                                         TRUE, NULL);
            g_free (path);
        }
    }
    if (pixbuf == NULL && icon != NULL) {
        GtkIconInfo *info = gtk_icon_theme_lookup_by_gicon (
            theme, icon, 24, GTK_ICON_LOOKUP_FORCE_SIZE);
        if (info != NULL) {
            pixbuf = gtk_icon_info_load_icon (info, NULL);
            g_object_unref (info);
        }
    }
    if (pixbuf == NULL) {
        GtkIconInfo *info = gtk_icon_theme_lookup_icon (
            theme, "application-x-executable", 24, GTK_ICON_LOOKUP_FORCE_SIZE);
        if (info != NULL) {
            pixbuf = gtk_icon_info_load_icon (info, NULL);
            g_object_unref (info);
        }
    }
    if (pixbuf != NULL) {
        gint width = gdk_pixbuf_get_width (pixbuf);
        gint height = gdk_pixbuf_get_height (pixbuf);
        if (width > 24 || height > 24) {
            gdouble factor = MIN (24.0 / width, 24.0 / height);
            gint target_width = MAX (1, (gint) (width * factor));
            gint target_height = MAX (1, (gint) (height * factor));
            GdkPixbuf *scaled = gdk_pixbuf_scale_simple (
                pixbuf, target_width, target_height, GDK_INTERP_BILINEAR);
            g_object_unref (pixbuf);
            pixbuf = scaled;
        }
    }
    return pixbuf;
}

static void refresh_results (GtkEditable *editable, gpointer user_data)
{
    SearchState *state = user_data;
    gtk_widget_set_visible (state->placeholder,
                            gtk_entry_get_text_length (GTK_ENTRY (editable)) == 0);
    const gchar *input = gtk_entry_get_text (GTK_ENTRY (editable));
    gchar *trimmed = g_strdup (input);
    g_strstrip (trimmed);

    GList *old_rows = gtk_container_get_children (GTK_CONTAINER (state->results));
    for (GList *l = old_rows; l != NULL; l = l->next)
        gtk_widget_destroy (GTK_WIDGET (l->data));
    g_list_free (old_rows);
    state->selected = 0;
    state->result_count = 0;

    if (*trimmed == '\0') {
        hide_results (state);
        g_free (trimmed);
        return;
    }

    gchar *needle = g_utf8_casefold (trimmed, -1);
    GList *apps = g_list_sort (g_app_info_get_all (), compare_apps);

    for (GList *l = apps; l != NULL && state->result_count < 8; l = l->next) {
        GAppInfo *app = G_APP_INFO (l->data);
        if (!g_app_info_should_show (app) || !app_matches (app, needle))
            continue;

        GtkWidget *button = gtk_button_new ();
        GtkWidget *row = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 10);
        gtk_widget_set_margin_start (row, 10);
        gtk_widget_set_margin_end (row, 10);
        gtk_widget_set_margin_top (row, 8);
        gtk_widget_set_margin_bottom (row, 8);
        gtk_style_context_add_class (gtk_widget_get_style_context (button),
                                     "linudex-search-result");

        GIcon *icon = g_app_info_get_icon (app);
        GdkPixbuf *pixbuf = load_app_icon (icon);
        GtkWidget *image = pixbuf != NULL
            ? gtk_image_new_from_pixbuf (pixbuf)
            : gtk_image_new ();
        if (pixbuf != NULL)
            g_object_unref (pixbuf);
        gtk_widget_set_size_request (image, 24, 24);
        GtkWidget *name = gtk_label_new (g_app_info_get_display_name (app));
        gtk_label_set_xalign (GTK_LABEL (name), 0.0f);
        gtk_label_set_ellipsize (GTK_LABEL (name), PANGO_ELLIPSIZE_END);

        gtk_box_pack_start (GTK_BOX (row), image, FALSE, FALSE, 0);
        gtk_box_pack_start (GTK_BOX (row), name, TRUE, TRUE, 0);
        gtk_container_add (GTK_CONTAINER (button), row);
        g_object_set_data_full (G_OBJECT (button), "linudex-app",
                                g_object_ref (app), g_object_unref);
        g_signal_connect (button, "clicked", G_CALLBACK (row_clicked), state);
        gtk_box_pack_start (GTK_BOX (state->results), button, FALSE, FALSE, 0);
        state->result_count++;
    }

    g_list_free_full (apps, g_object_unref);
    g_free (needle);
    g_free (trimmed);

    if (state->result_count == 0) {
        GtkWidget *message = gtk_label_new ("No applications found");
        gtk_widget_set_margin_top (message, 14);
        gtk_widget_set_margin_bottom (message, 14);
        gtk_box_pack_start (GTK_BOX (state->results), message, FALSE, FALSE, 0);
    }

    show_results (state, state->result_count ? state->result_count : 1);
    highlight_row (state);
}

static gboolean entry_button_press (GtkWidget *widget, GdkEventButton *event,
                                    gpointer user_data)
{
    SearchState *state = user_data;
    if (event->button == GDK_BUTTON_PRIMARY)
        xfce_panel_plugin_focus_widget (state->plugin, widget);
    return FALSE;
}

static gboolean entry_key_press (GtkWidget *widget, GdkEventKey *event,
                                 gpointer user_data)
{
    SearchState *state = user_data;
    (void) widget;
    if (event->keyval == GDK_KEY_Escape) {
        hide_results (state);
        gtk_entry_set_text (GTK_ENTRY (state->entry), "");
        return TRUE;
    }

    if (!gtk_widget_get_visible (state->popup) || state->result_count == 0)
        return FALSE;

    if (event->keyval == GDK_KEY_Down) {
        if (state->selected + 1 < state->result_count)
            state->selected++;
        highlight_row (state);
        return TRUE;
    }
    if (event->keyval == GDK_KEY_Up) {
        if (state->selected > 0)
            state->selected--;
        highlight_row (state);
        return TRUE;
    }
    if (event->keyval == GDK_KEY_Return || event->keyval == GDK_KEY_KP_Enter) {
        GList *rows = gtk_container_get_children (GTK_CONTAINER (state->results));
        GtkWidget *chosen = GTK_WIDGET (g_list_nth_data (rows, state->selected));
        GAppInfo *app = chosen != NULL
            ? g_object_get_data (G_OBJECT (chosen), "linudex-app") : NULL;
        if (app != NULL)
            launch_app (app, state);
        g_list_free (rows);
        return TRUE;
    }
    return FALSE;
}

static void free_state (GtkWidget *plugin_widget, gpointer user_data)
{
    SearchState *state = user_data;
    (void) plugin_widget;
    gtk_widget_destroy (state->popup);
    g_free (state);
}

static void load_css (void)
{
    gchar *path = g_build_filename (g_get_user_config_dir (),
                                    "linudex-search", "style.css", NULL);
    GtkCssProvider *css = gtk_css_provider_new ();
    GError *error = NULL;
    if (gtk_css_provider_load_from_path (css, path, &error)) {
        gtk_style_context_add_provider_for_screen (gdk_screen_get_default (),
            GTK_STYLE_PROVIDER (css), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    } else {
        g_warning ("LinuDex Search CSS (%s): %s", path, error->message);
        g_clear_error (&error);
    }
    g_object_unref (css);
    g_free (path);
}

/* Display a native-size opaque SVG and a real white label over the entry.
 * GTK's stock placeholder and GtkEntry icon are theme-muted on this panel;
 * overlay widgets preserve the exact v0.5.0 visual contrast. All overlays
 * allow pointer events through so clicks reach the GtkEntry beneath. */
static GtkWidget *make_search_overlay (SearchState *state)
{
    GtkWidget *overlay = gtk_overlay_new ();
    gtk_widget_set_size_request (overlay, 280, 36);
    gtk_widget_set_margin_top (overlay, 2);
    gtk_widget_set_margin_bottom (overlay, 2);
    gtk_container_add (GTK_CONTAINER (overlay), state->entry);

    gchar *path = g_build_filename (g_get_user_data_dir (), "linudex",
                                    "search-icon.svg", NULL);
    GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file_at_scale (path, 32, 36,
                                                           FALSE, NULL);
    GtkWidget *image;
    if (pixbuf != NULL) {
        image = gtk_image_new_from_pixbuf (pixbuf);
        g_object_unref (pixbuf);
    } else {
        image = gtk_image_new_from_icon_name ("system-search",
                                              GTK_ICON_SIZE_LARGE_TOOLBAR);
    }
    gtk_widget_set_halign (image, GTK_ALIGN_START);
    gtk_widget_set_valign (image, GTK_ALIGN_CENTER);
    gtk_widget_set_size_request (image, 32, 36);
    gtk_overlay_add_overlay (GTK_OVERLAY (overlay), image);
    gtk_overlay_set_overlay_pass_through (GTK_OVERLAY (overlay), image, TRUE);
    g_free (path);

    state->placeholder = gtk_label_new ("Pesquisar");
    gtk_widget_set_name (state->placeholder, "linudex-search-placeholder");
    gtk_widget_set_halign (state->placeholder, GTK_ALIGN_START);
    gtk_widget_set_valign (state->placeholder, GTK_ALIGN_CENTER);
    gtk_widget_set_margin_start (state->placeholder, 38);
    gtk_overlay_add_overlay (GTK_OVERLAY (overlay), state->placeholder);
    gtk_overlay_set_overlay_pass_through (GTK_OVERLAY (overlay),
                                          state->placeholder, TRUE);
    return overlay;
}

static void linudex_search_construct (XfcePanelPlugin *plugin)
{
    SearchState *state = g_new0 (SearchState, 1);
    state->plugin = plugin;
    load_css ();

    state->entry = gtk_entry_new ();
    gtk_widget_set_name (state->entry, "linudex-search");
    gtk_widget_set_size_request (state->entry, 280, 36);
    GtkWidget *overlay = make_search_overlay (state);

    /* A popup window is independent of the panel's GdkWindow clipping area.
     * Disable popup focus so the GtkEntry keeps receiving keystrokes. */
    state->popup = gtk_window_new (GTK_WINDOW_POPUP);
    gtk_widget_set_name (state->popup, "linudex-search-popup");
    gtk_window_set_decorated (GTK_WINDOW (state->popup), FALSE);
    gtk_window_set_accept_focus (GTK_WINDOW (state->popup), FALSE);
    gtk_window_set_focus_on_map (GTK_WINDOW (state->popup), FALSE);
    gtk_window_set_skip_taskbar_hint (GTK_WINDOW (state->popup), TRUE);
    gtk_window_set_skip_pager_hint (GTK_WINDOW (state->popup), TRUE);
    gtk_window_set_resizable (GTK_WINDOW (state->popup), FALSE);

    state->scroll = gtk_scrolled_window_new (NULL, NULL);
    gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (state->scroll),
                                    GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC);
    state->results = gtk_box_new (GTK_ORIENTATION_VERTICAL, 0);
    gtk_container_add (GTK_CONTAINER (state->scroll), state->results);
    gtk_container_add (GTK_CONTAINER (state->popup), state->scroll);

    g_signal_connect (state->entry, "button-press-event",
                      G_CALLBACK (entry_button_press), state);
    g_signal_connect (state->entry, "changed",
                      G_CALLBACK (refresh_results), state);
    g_signal_connect (state->entry, "key-press-event",
                      G_CALLBACK (entry_key_press), state);
    g_signal_connect (plugin, "destroy", G_CALLBACK (free_state), state);

    gtk_container_add (GTK_CONTAINER (plugin), overlay);
    gtk_widget_show_all (GTK_WIDGET (plugin));
}

XFCE_PANEL_PLUGIN_REGISTER (linudex_search_construct);
