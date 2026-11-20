# Solução de problemas — v0.5.2

[English](troubleshooting-v0.5.2.md)

Este documento registra os experimentos de segurança de navegação e integração com navegador Android da v0.5.2 do LinuDex, em um Galaxy S10+ com Samsung DeX, Debian 13 ARM64 por Termux/PRoot e XFCE. Os estados referem-se **ao dispositivo testado**, não a um comportamento universal.

## Índice de problemas

- [Navegadores Linux exigiam alternativa insegura para sandbox](#navegadores-linux-exigiam-alternativa-insegura-para-sandbox)
- [Falha no experimento com Bubblewrap](#falha-no-experimento-com-bubblewrap)
- [Desempenho insatisfatório do LibreWolf](#desempenho-insatisfatório-do-librewolf)
- [Samsung Internet pode ficar atrás do Debian](#samsung-internet-pode-ficar-atrás-do-debian)
- [Barra superior do DeX permanecia visível](#barra-superior-do-dex-permanecia-visível)
- [Lançador XFCE herdava a aparência da pesquisa antiga](#lançador-xfce-herdava-a-aparência-da-pesquisa-antiga)

---

## Navegadores Linux exigiam alternativa insegura para sandbox

### Sintomas

Chromium e Brave exigiam `--no-sandbox` ou não funcionavam de forma confiável com os requisitos normais de isolamento no PRoot testado.

### Diagnóstico

O PRoot não oferece necessariamente os mesmos mecanismos de isolamento de uma instalação convencional do Debian. `--no-sandbox` elimina proteções relevantes do navegador. O Firefox ESR também foi investigado, porém as evidências foram mistas: alguns processos apresentaram `NoNewPrivs: 1` e `Seccomp: 2`, enquanto user namespaces não estavam disponíveis; o sandbox completo não foi comprovado.

### Abordagem adotada

Utilizar o Samsung Internet nativo do Android como navegador principal. Manter o Chromium apenas nos WebApps específicos Netflix/YouTube já testados, deixando explícita sua limitação de sandbox. Flags de processos isoladas não constituem auditoria completa de segurança.

### Estado

**Estratégia definida e Samsung Internet validado. Isolamento seguro dos navegadores Linux não comprovado.**

---

## Falha no experimento com Bubblewrap

### Sintomas

Experimento de isolamento com GNOME Web / Bubblewrap falhou com:

```text
execvp /usr/bin/true: No such file or directory
```

### Diagnóstico

O Bubblewrap 0.12.0 não concluiu a operação testada dentro do PRoot. A causa exata não foi isolada de forma conclusiva.

### Abordagem adotada

Não considerar o Bubblewrap como sandbox funcional nessa instalação; priorizar o navegador nativo Android.

### Estado

**Experimento não resolvido, fora da solução final.**

---

## Desempenho insatisfatório do LibreWolf

### Sintomas

O LibreWolf abriu, mas apresentou lentidão em sites pesados, como ChatGPT, YouTube e GitHub.

### Diagnóstico

O aplicativo era funcional, porém a experiência prática no dispositivo não foi suficiente para navegação cotidiana. Não foi registrado benchmark reproduzível que comprovasse uma causa única.

### Abordagem adotada

Priorizar Samsung Internet no DeX. A desinstalação de LibreWolf e Firefox ESR ainda não foi confirmada.

### Estado

**Alternativa rejeitada para navegação cotidiana no dispositivo testado.**

---

## Samsung Internet pode ficar atrás do Debian

### Sintomas

O Samsung Internet aparece ao executar o lançador XFCE, mas pode desaparecer depois de clicar em um aplicativo do Debian/XFCE.

### Diagnóstico

O Samsung Internet é aplicativo Android exibido e gerenciado pelo Samsung DeX **sobre o desktop Debian/Termux:X11**, e não um programa X11 executado no guest Debian. A mudança de foco pode trazer o Debian para a frente do navegador Android.

### Solução de contorno validada

Clique novamente no lançador Samsung Internet no XFCE/Docklike. O aplicativo retorna ao primeiro plano no ambiente testado. O script utiliza:

```bash
/data/data/com.termux/files/usr/bin/am start --user 0 com.sec.android.app.sbrowser
```

### Estado

**Limitação esperada de foco/empilhamento; contorno pelo lançador validado.**

---

## Barra superior do DeX permanecia visível

### Sintomas

Maximizar o Samsung Internet não ocultava inicialmente a barra de título superior do DeX.

### Solução validada

Com o navegador em foco, pressione `F11`. O atalho ativou tela cheia e ocultou a barra no Galaxy S10+ testado. No teste do usuário, o mesmo atalho não funcionou no Chrome Android.

### Estado

**Resolvido para Samsung Internet na instalação DeX testada.**

---

## Lançador XFCE herdava a aparência da pesquisa antiga

### Sintomas

O novo lançador Samsung Internet mostrava o gráfico da pesquisa antiga do Windows, embora suas propriedades listassem somente o Samsung Internet.

### Diagnóstico

O CSS legado em `~/.config/gtk-3.0/gtk.css` utilizava seletores genéricos `#launcher-arrow` e fundo `search.svg`. O usuário localizou várias regras repetidas da antiga pesquisa v0.5.0, que interferiam em outros lançadores XFCE.

### Solução validada

Após backup, remover exclusivamente os blocos do seletor antigo, preservando as demais regras do painel. No dispositivo testado, ocupavam as linhas 111–213, porém não reutilize esses números sem examinar outra versão do CSS. Depois execute:

```bash
xfce4-panel -r
```

O plugin novo LinuDex Search utiliza CSS próprio e não depende dessas regras antigas.

### Estado

**Resolvido; aparência normalizada no lançador Samsung Internet.**
