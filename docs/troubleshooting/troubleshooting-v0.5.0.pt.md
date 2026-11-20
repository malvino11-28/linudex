# Troubleshooting — v0.5.0

[English](troubleshooting-v0.5.0.md)

Este documento reúne problemas e limitações observados durante a personalização da interface do Linudex v0.5.0, executado em Debian 13 ARM64 via Termux, PRoot-Distro, Termux:X11 e XFCE no Galaxy S10+. Os estados refletem os testes realizados na instalação de desenvolvimento; não representam garantias para outros dispositivos.

## Índice de problemas

- [Teclas mortas e atalhos do teclado brasileiro](#teclas-mortas-e-atalhos-do-teclado-brasileiro)
- [Firefox ESR travava em páginas complexas](#firefox-esr-travava-em-páginas-complexas)
- [Brave encerrava durante a inicialização](#brave-encerrava-durante-a-inicialização)
- [Chromium requer desativação da sandbox no ambiente testado](#chromium-requer-desativação-da-sandbox-no-ambiente-testado)
- [Desafios Cloudflare não concluíam no Chromium](#desafios-cloudflare-não-concluíam-no-chromium)
- [Netflix exigiu configuração específica no Chromium ARM64](#netflix-exigiu-configuração-específica-no-chromium-arm64)

---

## Teclas mortas e atalhos do teclado brasileiro

### Sintomas

A configuração inicial incorreta da variante brasileira fez combinações como `Ctrl+V` e `Super+E` executarem ações inesperadas. Depois de corrigido o mapeamento, o Termux:X11 recebia `dead_acute`, mas os acentos apareciam separados das letras em diferentes aplicações (por exemplo, `´a` em vez de `á`).

### Diagnóstico

A variante denominada “Nativo” não correspondia ao layout ABNT2 convencional. O layout XKB `br`, com variante vazia, corrigiu os atalhos. Ajustar o locale para `pt_BR.UTF-8` não resolveu isoladamente a composição. O problema persistiu inclusive com o método de entrada simples do GTK.

### Solução validada

No XFCE, selecionar layout brasileiro padrão (`br`, variante vazia). No aplicativo **Termux:X11 para Android**, ativar **Prefer scancodes when possible**. Manter o locale UTF-8 na sessão.

### Validação

Acentos, atalhos e layout ABNT2 funcionaram e permaneceram corretos após reinicialização.

### Estado

**Resolvido na configuração testada.** A opção de scancodes pertence ao aplicativo Android e não é restaurada apenas pelos arquivos XML do XFCE.

---

## Firefox ESR travava em páginas complexas

### Sintomas

Firefox ESR `140.15.0esr-1~deb13u1` ocasionalmente travava em páginas pesadas, incluindo ChatGPT. O comportamento persistiu com perfil novo, modo de diagnóstico e WebGL desativado. Foram vistas mensagens referentes a `org.freedesktop.UPower` e `RenderCompositorSWGL failed mapping default framebuffer, no dt`.

### Diagnóstico

Não foi estabelecida relação causal entre as mensagens e os travamentos; as tentativas não permitiram identificar a causa. Foi observado vários gigabytes de RAM ainda disponíveis durante ocorrências anteriores.

### Observação posterior

O Firefox ESR abriu páginas pesadas sem travar em uma sessão posterior, utilizando `DISPLAY=:1 MOZ_ENABLE_WAYLAND=0 firefox --no-remote`. Esse êxito não comprova que os parâmetros tenham eliminado a causa anterior.

### Estado

**Intermitente / causa não confirmada.** O Chromium foi testado como alternativa, sem remover necessariamente o Firefox ESR.

---

## Brave encerrava durante a inicialização

### Sintomas

O Brave `1.98.63` encerrava antes de abrir a janela, mostrando `Trace/breakpoint trap` e `content/zygote/zygote_linux.cc:662: write: Pipe quebrado (32)`, inclusive com perfil temporário.

### Diagnóstico

Foi considerada a possibilidade de incompatibilidade de versões recentes do Chromium com PRoot. O log disponível não confirmou a causa fatal exata do Brave.

### Estado

**Não resolvido; adiado para outra versão.** Não há lançador Brave validado para a v0.5.0.

---

## Chromium requer desativação da sandbox no ambiente testado

### Sintomas

Chromium `156.0.8078.79` (Debian 13) não inicia no PRoot sem `--no-sandbox`. A falha apresenta mensagem do zygote e pipe quebrado. Desativar somente a sandbox setuid não resolveu.

### Diagnóstico

Foi verificado PRoot `5.1.107.102`. Testes executados dentro do Debian com `unshare` retornaram sucesso em um caso, porém `/proc/self/ns` não estava disponível para verificar a criação real dos namespaces. No Termux original, `unshare --user --map-root-user` retornou `Invalid argument` e código de saída `1`.

Esses resultados indicam limitações de namespace/isolamento na instalação testada, sem identificar isoladamente todos os mecanismos envolvidos no encerramento do Chromium.

### Solução alternativa usada

Iniciar o Chromium com `--no-sandbox`, em alguns testes também com `--disable-gpu-sandbox`, `GALLIUM_DRIVER=virpipe`, `--use-gl=egl` e `--ignore-gpu-blocklist`.

**Risco:** `--no-sandbox` desativa uma camada crítica de segurança. A configuração funcional não deve ser descrita como navegação segura equivalente a um Chromium padrão. Não utilizar para conteúdo sensível e não distribuir como configuração segura por padrão.

### Estado

**Funcional com limitação de segurança conhecida; isolamento não validado.**

---

## Desafios Cloudflare não concluíam no Chromium

### Sintomas

Alguns sites protegidos por Cloudflare não concluíam a validação no Chromium. Uma extensão de User-Agent não corrigiu o comportamento.

### Diagnóstico

O Chromium geral estava utilizando um User-Agent que imitava o ChromeOS, necessário para um teste anterior com Netflix. Ao remover essa substituição global, os desafios Cloudflare testados passaram a funcionar.

### Solução validada

Utilizar o User-Agent normal na navegação geral e manter o User-Agent ChromeOS apenas no aplicativo específico da Netflix, quando necessário.

### Estado

**Resolvido.**

---

## Netflix exigiu configuração específica no Chromium ARM64

### Sintomas

A Netflix não funcionava na configuração inicial do Chromium Debian ARM64.

### Solução experimental validada no aparelho

Foi utilizado o instalador externo `AsahiLinux/widevine-installer` e uma identificação de navegador compatível com ChromeOS. A Netflix foi instalada como WebApp pelo menu `Cast, save and share` do Chromium e seu lançador `.desktop` foi personalizado, incluindo `--app`, `--class` e `StartupWMClass` para integração individual ao Docklike.

### Validação

Reprodução de um filme completo, com recarregamentos pontuais não diagnosticados do player. O funcionamento foi validado somente no ambiente testado.

### Estado

**Funcional na instalação testada.**
