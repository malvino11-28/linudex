## PulseAudio falhava durante o cold boot e interrompia a inicialização automática

### Sintomas

Ao ligar o Galaxy S10+ já conectado ao Samsung DeX, o Termux:Boot era executado normalmente e iniciava o `start-linudex.sh`.

Durante a sequência de inicialização, o PulseAudio falhava com:

```text
E: [pulseaudio] main.c: Daemon startup failed.
```

Como o `start-linudex.sh` utiliza:

```bash
set -euo pipefail
```

a falha do PulseAudio interrompia o restante do script.

Na prática, isso fazia a inicialização automática parecer um problema relacionado ao Termux:X11 ou ao Samsung DeX, pois o ambiente gráfico não era aberto corretamente no display externo.

### Diagnóstico

O `start-linudex.sh` já tentava encerrar uma instância anterior do PulseAudio antes de iniciar uma nova:

```bash
pulseaudio -k 2>/dev/null || true
```

Porém, encerrar o daemon não removia necessariamente o estado temporário deixado pelo PulseAudio.

Foi então testada a remoção do diretório de runtime:

```bash
rm -rf "$TMPDIR/pulse"
```

antes de iniciar o novo daemon.

Após essa alteração, o PulseAudio iniciou normalmente durante o cold boot e a sequência automática continuou até o Termux:X11 e o Debian/XFCE.

### Causa

Estado temporário residual do PulseAudio em:

```text
$TMPDIR/pulse
```

podia impedir uma nova instância do daemon de iniciar corretamente durante o boot.

Apenas executar `pulseaudio -k` não era suficiente para garantir uma inicialização limpa.

### Solução

O `start-linudex.sh` foi alterado para limpar o estado residual do PulseAudio antes de iniciar o bridge de áudio:

```bash
log 'Clearing stale PulseAudio server...'
pulseaudio -k 2>/dev/null || true
sleep 1

log 'Clearing stale PulseAudio runtime state...'
rm -rf "$TMPDIR/pulse"

log 'Starting PulseAudio bridge...'
pulseaudio \
    --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
```

### Validação

Após a alteração, novos testes de cold boot foram realizados com o Samsung DeX conectado.

A sequência passou a funcionar corretamente:

```text
Android
    ↓
Termux:Boot
    ↓
PulseAudio
    ↓
Termux:X11
    ↓
Debian / XFCE
```

O Termux:X11 também passou a abrir automaticamente no DeX sem intervenção manual.

O erro:

```text
E: [pulseaudio] main.c: Daemon startup failed.
```

não foi reproduzido novamente durante os testes realizados após a correção.

### Estado

**Resolvido na v0.2.1.**

A correção foi incorporada ao `start-linudex.sh`.
