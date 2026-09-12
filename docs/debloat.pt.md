# Debloat do Android

[English](debloat.md)

## Objetivo

Reduzir software Android/OEM desnecessário preservando os serviços necessários para Samsung DeX, rede, USB, áudio e o ambiente host do Linux.

O objetivo é um Android mínimo **e estável**, e não atingir a menor quantidade possível de pacotes.

## Ferramenta

O debloat foi realizado a partir do Windows 10 usando o **[UAD-ng (Universal Android Debloater Next Generation)](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation)** via ADB.

## Procedimento utilizado na v0.1

1. Registrar o baseline do sistema original e a quantidade de pacotes instalados.
2. Criar um snapshot no UAD-ng antes de alterar os estados dos pacotes.
3. Processar primeiro os pacotes OEM classificados como recomendados.
4. Revisar separadamente os pacotes Google, carrier e miscellaneous.
5. Preservar Samsung DeX e a infraestrutura principal do Android.
6. Reiniciar e validar DeX, rede, entrada e funcionamento básico do Android após cada lote importante.
7. Remover manualmente os aplicativos visíveis claramente desnecessários quando apropriado.

## Componentes preservados intencionalmente

As seguintes categorias foram tratadas como críticas durante a v0.1:

- Componentes do Samsung DeX / modo desktop.
- System UI e Configurações do Android.
- Instalador de pacotes e infraestrutura de permissões.
- Wi-Fi e pilha de rede.
- Serviços relacionados a USB / DisplayPort / HDMI.
- Bluetooth e serviços de áudio.
- Providers de armazenamento e documentos.
- Android System WebView.
- Google Play Services / componentes de framework necessários ao ambiente Android restante.

## Pacotes do Samsung DeX

Os seguintes pacotes do DeX foram preservados:

```text
com.sec.android.desktopmode.uiservice
com.samsung.desktopsystemui
com.samsung.dexonpc
com.sec.android.app.desktoplauncher
```

## Validação

Após a etapa de debloat, Android e Samsung DeX iniciaram normalmente e a instalação do Linux prosseguiu sem regressões atribuídas ao debloat.

O baseline original registrou **477 pacotes Android instalados**. A contagem final pós-debloat foi de **197 pactoes**. Creio que seja possível deixar essa quantidade ainda menor, porém não explorei tanto os pacotes mais sensíveis.

## Ajustes relacionados em tempo de execução

Configurações como bateria sem restrições para Termux, RAM Plus e o workaround para processos phantom do Android são configurações do host/runtime, e não ações de debloat. Elas estão documentadas em [Software](software.pt.md) e [Troubleshooting](troubleshooting.pt.md).
