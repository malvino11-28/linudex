# Troubleshooting — v0.3.0

[English](troubleshooting-v0.3.0.md)

Problemas observados durante o desenvolvimento da camada experimental de compatibilidade x86/x86-64. Os registros descrevem a configuração testada no Galaxy S10+ e não significam que todos os aplicativos funcionarão.

## Índice de problemas

- [Inicialização .NET do DepotDownloader](#depotdownloader-não-conseguiu-inicializar-o-coreclr)
- [Consumo de memória da Steam](#steamwebhelper-consumiu-grande-parte-da-memória-disponível)
- [Falha de shader no Seraph com HUD de FPS](#seraph-falhou-com-gallium_hudfps)
- [Inicialização gráfica do 9 Kings](#9-kings-falhou-na-inicialização-gráfica)
- [Terraria solicitou o cliente Steam](#terraria-solicitou-a-inicialização-pela-steam)
- [Encerramento inseguro do Wine](#encerramento-experimental-do-wine-terminava-outros-processos)

---

## DepotDownloader não conseguiu inicializar o CoreCLR

### Sintomas

O DepotDownloader ARM64 inicialmente falhou no Android/PRoot com:

```text
GC heap initialization failed with error 0x8007000E
Failed to create CoreCLR, HRESULT: 0x8007000E
```

### Diagnóstico e solução alternativa

O runtime .NET não conseguiu inicializar a reserva de memória esperada nesse ambiente. A aplicação iniciou após a definição de:

```bash
export DOTNET_GCHeapHardLimit=1C0000000
```

O valor hexadecimal limita o heap gerenciado pelo coletor de lixo e não representa a quantidade de RAM física disponível. O DepotDownloader 3.4.0 conseguiu posteriormente baixar os arquivos de Seraph's Last Stand autorizados à conta.

### Estado

**Solução alternativa confirmada no ambiente testado.**

---

## SteamWebHelper consumiu grande parte da memória disponível

### Sintomas

O cliente Steam Windows foi instalado e autenticado, mas iniciou vários processos `steamwebhelper.exe`, consumiu muita RAM e swap e apresentou inicialização bastante lenta.

### Diagnóstico e solução alternativa

Opções da interface Steam, experimentos com Box64 e alterações nas configurações do CEF não reduziram suficientemente o consumo de memória. O DepotDownloader ofereceu uma alternativa ARM64 para obter arquivos que a conta tinha permissão para baixar. Alguns títulos ainda exigem Steam na inicialização.

### Estado

**A interface Steam permanece inadequada para o fluxo de jogos testado.**

---

## Seraph falhou com `GALLIUM_HUD=fps`

### Sintomas

O Seraph's Last Stand havia funcionado anteriormente, mas deixou de abrir após habilitar o HUD de FPS. O VirGL registrou erros de compilação de shaders, incluindo:

```text
Shader failed to compile
ERROR: 0:4: 'in' : cannot declare arrays of this qualifier
Dropping rendering due to missing shaders
```

### Diagnóstico e solução

A remoção do `GALLIUM_HUD=fps` permitiu iniciar o jogo novamente. Não foi necessário substituir o Wine, Box64 ou os drivers gráficos.

```bash
env -u GALLIUM_HUD -u LIBGL_SHOW_FPS ~/xow64 r "Seraph's Last Stand.exe"
```

Execute o comando dentro da pasta do jogo no prefixo Wine ativo.

### Estado

**Resolvido ao desativar o HUD incompatível.**

---

## 9 Kings falhou na inicialização gráfica

### Sintomas

O jogo abriu brevemente, fechou e iniciou a Steam. O log da Unity 6000.3.8f1 mostrou:

```text
Direct3D 11.0 [level 10.1]
ERROR: Shader Hidden/CoreSRP/CoreCopy shader is not supported
No SRP present, no compute shader support
```

Forçar OpenGL 4.1 produziu `InitializeEngineGraphics failed`.

### Diagnóstico

O caminho WineD3D/VirGL expôs recursos gráficos insuficientes para alguns shaders utilizados pelo jogo. A abertura da Steam pode estar relacionada a uma exigência independente do Steamworks, mas o log fornecido não confirmou essa hipótese como causa definitiva do encerramento.

### Estado

**Não executou na configuração v0.3.0.** Não houve benchmark de partida.

---

## Terraria solicitou a inicialização pela Steam

### Sintomas

O executável Linux x86-64 iniciou após a correção das permissões, mas apresentou:

```text
Please launch the game from your Steam client
```

### Diagnóstico

O executável distribuído não aceitou inicialização independente. Essa mensagem não indica falha comprovada da GPU nem do Box64.

### Estado

**Bloqueado pela exigência de inicialização via Steam na distribuição testada.**

---

## Encerramento experimental do Wine terminava outros processos

### Sintomas

O comando experimental `~/xow64 q` podia encerrar processos não relacionados ao Wine, incluindo XFCE/Termux:X11.

### Solução

Não utilize `~/xow64 q` nem comandos amplos de encerramento de processos na rotina de desligamento do Wine. O ambiente testado utiliza `~/stop-xow64-wine.sh` para encerrar o prefixo selecionado sem desligar o desktop. Revise o script antes de publicá-lo.

### Estado

**Encerramento seguro e restrito ao prefixo testado localmente; script ainda não publicado no repositório.**
