# Troubleshooting — v0.2.0

[English](troubleshooting-v0.2.0.md)

Problemas encontrados durante o desenvolvimento da versão v0.2.0 do Linudex e seus diagnósticos confirmados, workarounds ou estado atual.

Problemas já documentados na v0.1.0 não são repetidos aqui, exceto quando apresentaram um comportamento novo durante o desenvolvimento desta versão.

## Índice de problemas

- [Layout de teclado pt-BR](#layout-de-teclado-pt-br-não-permitia-digitar-acentos-corretamente)
- [Falha na inicialização automática](#termuxboot-não-conseguia-executar-start-linudexsh)
- [Termux:X11 não abria automaticamente](#termuxx11-não-abriu-automaticamente-durante-o-boot)

---

## Layout de teclado pt-BR não permitia digitar acentos corretamente

### Sintomas

Durante a configuração do teclado no Debian para o layout brasileiro pt-BR, alguns caracteres funcionavam corretamente, incluindo:

```text
ç
```

porém não era possível digitar caracteres acentuados normalmente.

Combinações esperadas com teclas mortas, como:

```text
´ + a → á
~ + a → ã
^ + e → ê
```

não produziam os caracteres esperados.

### Diagnóstico

Foram testadas alterações no layout de teclado através das configurações do XFCE e também tentativas de configuração diretamente pelo terminal dentro do Debian.

Apesar disso, o comportamento dos acentos permaneceu incorreto.

Como o Linudex estava sendo utilizado através do Samsung DeX conectado a um computador, ainda existiam várias camadas envolvidas no processamento das teclas:

```text
teclado físico do computador
        ↓
sistema operacional do computador
        ↓
Samsung DeX
        ↓
Android
        ↓
Termux:X11
        ↓
XFCE / Debian
```

O caractere `ç` funcionar enquanto as dead keys não funcionavam corretamente indicou que o problema poderia não estar apenas no layout configurado dentro do Debian.

### Causa

**Ainda não confirmada.**

A principal hipótese atual é uma incompatibilidade ou tratamento incorreto de dead keys durante o uso do Samsung DeX conectado ao computador.

Ainda não foi possível determinar em qual camada da cadeia de entrada o comportamento é introduzido.

### Tentativas realizadas

O layout brasileiro foi configurado através do XFCE e também foram realizadas tentativas de ajuste diretamente pelo terminal.

Essas alterações não corrigiram o comportamento dos acentos no ambiente de teste atual.

### Próximo teste

O problema será testado novamente quando o hardware definitivo estiver disponível, utilizando:

```text
Galaxy S10+
    ↓
USB-C hub
    ├── teclado físico
    ├── mouse
    └── monitor HDMI
```

Esse cenário elimina o computador intermediário e permitirá verificar diretamente o comportamento do teclado entre:

```text
teclado USB
    ↓
Android / DeX
    ↓
Termux:X11
    ↓
Debian / XFCE
```

Caso os acentos funcionem corretamente nesse ambiente, o problema poderá ser associado à utilização do DeX através do computador.

Caso permaneça, será necessário investigar as configurações de layout e dead keys entre Android, Termux:X11 e XKB.

### Estado

**Pendente.**

A configuração de teclado pt-BR funciona parcialmente, incluindo o caractere `ç`, mas o suporte a dead keys e caracteres acentuados ainda precisa ser validado no hardware final antes de uma correção definitiva.

---

## Termux:Boot não conseguia executar `start-linudex.sh`

### Sintomas

O Termux:Boot era executado corretamente após a inicialização do Android e chegava até:

```text
[Boot] Starting Linudex...
```

porém o Linudex não iniciava.

O arquivo `~/linudex-boot.log` registrava:

```text
/data/data/com.termux/files/home/.termux/boot/20-start-linudex: line 24:
/data/data/com.termux/files/home/start-linudex.sh#!/data/data/com.termux/files/usr/bin/bash:
No such file or directory
```

### Diagnóstico

O Termux:Boot havia funcionado corretamente até a etapa responsável por executar o script principal.

O caminho mostrado no erro continha duas partes que deveriam estar separadas:

```text
start-linudex.sh
```

e:

```text
#!/data/data/com.termux/files/usr/bin/bash
```

### Causa

Durante a edição do arquivo `20-start-linudex`, o comando:

```bash
exec "$HOME/start-linudex.sh"
```

foi acidentalmente concatenado com o shebang de outro script.

O sistema tentou interpretar toda a sequência como o nome de um arquivo executável inexistente.

### Solução

O arquivo:

```text
~/.termux/boot/20-start-linudex
```

foi corrigido para terminar com:

```bash
echo "[Boot] Starting Linudex..."

exec "$HOME/start-linudex.sh"
```

O conteúdo foi conferido utilizando:

```bash
nl -ba ~/.termux/boot/20-start-linudex
```

e as permissões de execução foram garantidas:

```bash
chmod +x ~/.termux/boot/20-start-linudex
chmod +x ~/start-linudex.sh
```

### Validação

Após a correção e uma nova reinicialização do Galaxy S10+, o Termux:Boot executou `start-linudex.sh` e o ambiente Linudex iniciou automaticamente.

### Estado

**Resolvido.**

---

## Termux:X11 não abriu automaticamente durante o boot

### Sintomas

Após corrigir o Termux:Boot, a pilha do Linudex era iniciada automaticamente:

```text
PulseAudio
Termux:X11 server
Debian
XFCE
```

porém a interface Android do Termux:X11 não era trazida automaticamente para a tela.

O ambiente Linux estava sendo executado, mas ainda era necessário abrir o aplicativo Termux:X11 manualmente.

### Diagnóstico

`start-linudex.sh` já executava o servidor X11 e também utilizava o Activity Manager do Android:

```bash
am start \
    --user 0 \
    -n com.termux.x11/com.termux.x11.MainActivity
```

O mesmo comando funcionava quando `start-linudex.sh` era iniciado manualmente pelo usuário.

A diferença ocorria quando o script era executado automaticamente pelo Termux:Boot, enquanto o Termux estava em segundo plano.

### Causa

O Android restringia a abertura da Activity do Termux:X11 quando a solicitação partia do Termux executando em segundo plano durante o boot.

Além disso, a saída do comando `am start` estava originalmente sendo descartada, dificultando o diagnóstico:

```bash
>/dev/null 2>&1 || true
```

### Solução

Foi concedida ao Termux a permissão:

```text
Configurações
→ Aplicativos
→ Acesso especial
→ Aparecer sobre outros apps
→ Termux
```

O comando responsável por abrir o Termux:X11 também passou a ser executado explicitamente pelo `start-linudex.sh`.

Durante o diagnóstico, a supressão de saída foi removida para permitir visualizar o resultado do Activity Manager.

### Validação

Após reiniciar o dispositivo novamente:

1. o Android iniciou normalmente;
2. o Termux:Boot executou o script de inicialização;
3. o Linudex foi iniciado;
4. o Termux:X11 abriu automaticamente;
5. a sessão XFCE ficou disponível sem abertura manual do aplicativo.

### Estado

**Resolvido.**
