# Troubleshooting

[English](troubleshooting.md)

Problemas encontrados durante o desenvolvimento do Linudex e seus diagnósticos confirmados, workarounds ou estado atual.

## Índice de problemas

- [Wi-Fi](#wi-fi-conectado-mas-sem-acesso-à-internet)
- [Pacotes não encontrados](#pacotes-do-termux-retornavam-unable-to-locate-package)
- [Permissões do sudo](#sudo-recusava-o-usuário-linudex)
- [XFCE não conseguia abrir o display](#xfce-retornava-cannot-open-display)
- [Servidor X11 já em execução](#server-already-running-com-janela-preta-no-termuxx11)
- [Phantom Process Killer / Signal 9](#sessão-do-termux-encerrada-com-signal-9)
- [Aquecimento](#preocupação-inicial-com-aquecimento)

## Wi-Fi conectado, mas sem acesso à internet

### Sintomas

O Galaxy S10+ conectava ao Wi-Fi, mas o Android informava que o acesso à internet estava indisponível. Outros dispositivos na mesma rede funcionavam normalmente.

### Diagnóstico

Foram consideradas falha do roteador, configuração de DNS, configurações do Wi-Fi e problemas de rede específicos do aparelho. O roteador foi descartado porque os outros dispositivos possuíam acesso normal à internet.

### Causa

A data e a hora do sistema estavam incorretas. Isso fazia conexões seguras HTTPS/TLS falharem porque os certificados pareciam estar fora de seu período de validade.

### Solução

Ativar data e hora automáticas:

```text
Configurações → Gerenciamento geral → Data e hora → Data e hora automáticas
```

### Validação

O Wi-Fi continuou conectado, sites HTTPS voltaram a funcionar e os repositórios de pacotes ficaram acessíveis normalmente.

### Estado

**Resolvido.**

---

## Pacotes do Termux retornavam `Unable to locate package`

### Sintomas

As primeiras tentativas de instalar pacotes básicos do Termux, como Git, curl e PRoot-Distro, retornavam:

```text
E: Unable to locate package ...
```

### Causa

O índice de pacotes não havia sido carregado corretamente a partir do repositório configurado no Termux.

### Solução

O repositório configurado foi verificado e `pkg update` foi executado novamente com sucesso antes de tentar instalar os pacotes.

### Estado

**Resolvido.**

---

## `sudo` recusava o usuário `linudex`

### Sintomas

`id linudex` indicava associação ao grupo `sudo`, porém a sessão iniciada pelo PRoot-Distro não expunha esse grupo suplementar e `sudo whoami` informava que `linudex` não estava no arquivo sudoers.

### Causa

A sessão de login do PRoot-Distro não reproduziu a associação ao grupo suplementar da forma esperada pela regra padrão do grupo sudo no Debian.

### Solução

Foi criada uma regra explícita com `visudo -f /etc/sudoers.d/linudex`:

```text
linudex ALL=(ALL:ALL) ALL
```

O arquivo recebeu permissão `440` e `visudo -c` foi utilizado para validar a configuração.

### Validação

```bash
sudo whoami
```

retornou:

```text
root
```

### Estado

**Resolvido.**

---

## XFCE retornava `cannot open display`

### Sintomas

Executar `xfce4-session --version` antes de iniciar um servidor X retornava:

```text
xfce4-session: cannot open display
```

### Causa

`xfce4-session` esperava um display X11. Naquele momento o Termux:X11 ainda não havia sido iniciado e `DISPLAY` não estava configurado.

### Solução

Termux:X11 foi instalado e iniciado, o Debian foi acessado com `--shared-tmp`, `DISPLAY=:1` foi exportado e a sessão XFCE foi iniciada através do D-Bus.

### Estado

**Resolvido.**

---

## `Server already running` com janela preta no Termux:X11

### Sintomas

Depois de uma interrupção da sessão Termux/Debian, o desktop Linux fechou. Ao tentar iniciar novamente, apareceu:

```text
Server already running
```

enquanto o aplicativo Termux:X11 permanecia com uma tela preta.

### Causa

A árvore de processos Debian/XFCE havia sido encerrada, mas o processo do servidor Termux:X11 continuou ativo em segundo plano.

### Solução

Encerrar o servidor X11 residual antes de iniciar novamente:

```bash
pkill termux-x11
am broadcast -a com.termux.x11.ACTION_STOP -p com.termux.x11
```

Se necessário, confirme o estado do processo com `pgrep`/`ps` antes de usar um encerramento forçado.

### Estado

**Resolvido.**

---

## Sessão do Termux encerrada com `signal 9`

### Sintomas

Enquanto Debian/XFCE estava em execução, o Termux ocasionalmente encerrava a árvore de processos com:

```text
[Process completed (signal 9) - press Enter]
```

### Diagnóstico

As falhas deixaram de ocorrer após aumentar o limite de processos phantom do Android 12. Isso associou fortemente o encerramento ao Phantom Process Killer do Android, e não a uma instabilidade do Debian.

### Workaround utilizado nos testes da v0.1

Termux e Termux:X11 foram configurados sem restrições de bateria. Depois, o limite de processos phantom foi aumentado via ADB para a sessão de teste:

```bash
adb shell "/system/bin/device_config set_sync_disabled_for_tests until_reboot"
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
```

O valor configurado pode ser conferido com:

```bash
adb shell "/system/bin/device_config get activity_manager max_phantom_processes"
```

### Validação

Após o ajuste, as cargas de benchmark — incluindo Firefox ESR reproduzindo YouTube em 1440p — foram concluídas sem os encerramentos aleatórios anteriores por `signal 9`.

### Estado

**Workaround confirmado para a v0.1.** A configuração atual de teste pode precisar ser reaplicada após reiniciar o aparelho, pois foi testada intencionalmente com comportamento `until_reboot`.

---

## Preocupação inicial com aquecimento

### Sintomas

Durante os primeiros testes, foi percebido um ponto quente localizado na região da tela danificada pouco depois da inicialização.

### Resultados

O ponto quente se correlacionou com a tela integrada danificada permanecendo ativa. Com a tela do telefone desligada durante o uso do DeX, o aparelho esfriou consideravelmente. Os benchmarks posteriores da v0.1 permaneceram estáveis, com temperaturas da bateria registradas entre 27.8 °C e 33.0 °C.

### Estado

**Nenhuma instabilidade térmica foi reproduzida nos testes de software da v0.1.** A validação do gabinete final e da refrigeração ativa permanece como trabalho futuro de hardware.
