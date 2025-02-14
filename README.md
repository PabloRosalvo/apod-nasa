# APOD NASA

## Descrição

O APOD NASA é um aplicativo móvel desenvolvido para exibir a Imagem Astronômica do Dia ("Astronomy Picture of the Day" - APOD), fornecida pela NASA. Os usuários podem buscar imagens e vídeos astronômicos por data, visualizar detalhes sobre cada item e adicionar favoritos para acesso rápido. O projeto prioriza uma interface simples e intuitiva, garantindo uma experiência fluida e eficiente.

## Funcionalidades

📷 Exibição da imagem/vídeo do dia
🔍 Busca por datas passadas
⭐ Favoritar imagens e vídeos para acesso rápido
⚡ Interface responsiva, priorizando carregamento rápido
🚨 Exibição de modais de erro para falhas na API
🔄 Atualização automática ao abrir o aplicativo
🛠 Módulo de networking via SPM para fácil reutilização

Tecnologias Utilizadas
Linguagem: Swift
Arquitetura: MVVM-C (Model-View-ViewModel-Coordinator)
Frameworks & Ferramentas:
Combine para programação reativa
Kingfisher para carregamento de imagens
UIKit (ViewCode) para construção da interface
Quick e Nimble para testes unitários e de snapshot
URLSession para requisições de rede
Swift Package Manager (SPM) para gerenciamento do módulo de networking

## Arquitetura e Benefícios

A arquitetura MVVM-C reativa com Combine garante um código modular e escalável, facilitando a manutenção e testabilidade. A separação de responsabilidades entre Model, ViewModel e Coordinator, combinada com bindings reativos, permite que a interface reaja automaticamente às mudanças de estado, melhorando a experiência do usuário.

Cobertura de Testes: O projeto possui quase 100% de cobertura de testes nas classes principais, garantindo alta qualidade e testabilidade.

Arquitetura Organizada: O projeto segue uma arquitetura MVVM-C bem definida, com clara separação de responsabilidades, facilitando a manutenção e escalabilidade.

Programação Reativa: Utilização de Combine para garantir uma interface reativa e fluida, bem definido entre as camadas.

Testes Simples e Eficazes: Uso de Quick e Nimble para testes fáceis de entender, mesmo para iniciantes.

## Módulo de Networking via SPM

O projeto conta com um módulo de networking desacoplado, gerenciado via Swift Package Manager (SPM), permitindo reutilização em outros projetos. Esse módulo simplifica as chamadas de API, exigindo apenas o envio do endpoint correto.

✅ Benefícios do Módulo de Networking via SPM

Totalmente desacoplado: pode ser utilizado em outros projetos
Facilidade de manutenção: basta atualizar o módulo para refletir mudanças
Código mais limpo e reutilizável: elimina duplicação e facilita testes

O APIEndpoint contém os endpoints necessários para buscar infos da NASA.

## Diferenciais
✅ Tests: O projeto possui uma cobertura de testes focado em nas classes principais, garantindo qualidade e testabilidade.
🔥 Arquitetura Organizada: O padrão MVVM-C bem definido facilita a escalabilidade e manutenção.
⚡ Programção Reativa: Uso de Combine para garantir uma interface responsiva.
🛠 Testes Simples e Eficazes: Quick e Nimble são utilizados para testes unitários e de snapshot.
🌐 Módulo de Networking via SPM: Facilita integrações e reutilização.

## Instalação
### Pré-requisitos:
- **Version Version 16.2 (16C5032a)** 
- **iOS 15.0** ou superior
- **SPM** 

### Simplicidade para baixar e rodar o projeto:
1. **Baixar o projeto**: O download do projeto é simples e rápido. Basta seguir os comandos abaixo.
2. **Configuração fácil**: O projeto está pronto para ser rodado com um simples comando, tornando a instalação descomplicada.
3. **Compatibilidade**: O projeto foi desenvolvido e testado para funcionar com o Xcode 16.2 e iOS 15 garantindo uma experiência fluida.

### Clonando o Repositório
1. git clone https://github.com/PabloRosalvo/apod-nasa.git
2. O projeto está em SPM, pode ir em File -> Packages - Reset
   
