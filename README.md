# APOD NASA

## Descrição
O APOD NASA é um aplicativo móvel que exibe a Imagem Astronômica do Dia (Astronomy Picture of the Day - APOD) da NASA. Os usuários podem buscar imagens e vídeos astronômicos por data, visualizar detalhes e salvar seus favoritos. O projeto foi desenvolvido utilizando Combine, trazendo uma abordagem reativa para atualização da UI de forma fluida e desacoplada.

📌 Importante: Este projeto foi implementado em Combine no UIKit para aprofundar meus conhecimentos em programação reativa. No futuro, pretendo migrá-lo para SwiftUI, aproveitando os benefícios da reatividade nativa da plataforma. Graças ao uso de Combine, essa migração se torna ainda mais simples e natural, pois grande parte da lógica reativa implementada na ViewModel pode ser reaproveitada no SwiftUI, eliminando a necessidade de mudanças estruturais significativas. Essa abordagem reforça minha capacidade de desenvolver soluções reativas tanto no UIKit quanto no SwiftUI, garantindo flexibilidade, escalabilidade e um código ainda mais enxuto e eficiente

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

Cobertura de Testes: O projeto possui cobertura de testes nas classes principais, garantindo alta qualidade e testabilidade.

Arquitetura Organizada: O projeto segue uma arquitetura MVVM-C bem definida, com clara separação de responsabilidades, facilitando a manutenção e escalabilidade.

Programação Reativa: Utilização de Combine para garantir uma interface reativa e fluida, bem definido entre as camadas.

Testes Simples e Eficazes: Uso de Quick e Nimble para testes fáceis de entender, mesmo para iniciantes.

iOS 13: O Combine foi introduzido no iOS 13, tornando possível a adoção dessa abordagem reativa sem a necessidade de bibliotecas externas como RxSwift.
Xcode 11: O suporte ao Combine e ao Swift Package Manager (SPM) foi introduzido no Xcode 11, permitindo o uso nativo desse framework para manipulação de fluxos assíncronos.
Caso o objetivo seja migrar para SwiftUI, a versão mínima recomendada seria: iOS 14+.

## Módulo de Networking via SPM

O projeto conta com um módulo de networking desacoplado, gerenciado via Swift Package Manager (SPM), permitindo reutilização em outros projetos. Esse módulo simplifica as chamadas de API, exigindo apenas o envio do endpoint correto.

✅ Benefícios do Módulo de Networking via SPM

Totalmente desacoplado: pode ser utilizado em outros projetos
Facilidade de manutenção: basta atualizar o módulo para refletir mudanças
Código mais limpo e reutilizável: elimina duplicação e facilita testes

O APIEndpoint contém os endpoints necessários para buscar infos da NASA.

## Published e Publisher para Atualizar a UI no UIKit
O UIKit não foi projetado para ser totalmente reativo como o SwiftUI, mas com o uso de Combine, conseguimos fazer com que as Views do UIKit sejam atualizadas automaticamente sempre que os dados na ViewModel mudam. Essa abordagem melhora a separação de responsabilidades, evita atualizações manuais da UI, e torna o código mais limpo, desacoplado e reativo.

📌 Como isso funciona?
A ViewModel expõe estados observáveis com @Published.
A ViewController se inscreve (sink) nos Publishers da ViewModel.
Quando os valores mudam na ViewModel, a View recebe automaticamente as atualizações.

## Compatibilidade e Escolha do iOS 15
O projeto foi desenvolvido com Swift Concurrency, utilizando Sendable e @MainActor para garantir segurança na concorrência e melhor gerenciamento da UI com Combine. Reduzindo riscos de data races e tornando o código mais seguro e previsível.

Sendable: Garante segurança ao compartilhar objetos entre threads.
@MainActor: Mantém atualizações da UI na Main Thread, evitando problemas de concorrência.
Essa abordagem proporciona um código mais seguro, reativo e escalável.

✅ Benefícios de usar Sendable e @MainActor

Código mais seguro 🚀 → Evita bugs difíceis de rastrear causados por concorrência.

Menos crashes e corrupção de dados 🔒 → O compilador verifica se as estruturas são seguras para concorrência.

Melhor organização 📌 → Garante que a UI seja sempre atualizada na Main Thread.

Maior escalabilidade 📈 → Permite criar código assíncrono robusto e preparado para multitarefa.

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
   


### Screenshots e Demonstração

Teste Snapshot

<img width="1512" alt="Captura de Tela 2025-02-14 às 14 59 15" src="https://github.com/user-attachments/assets/3f198dff-5803-4b3f-93aa-2c191fb9a9e9" />

<img width="1512" alt="Captura de Tela 2025-02-14 às 15 00 00" src="https://github.com/user-attachments/assets/f791b660-df7d-438c-bd36-f0a3d59ac667" />

https://github.com/user-attachments/assets/d2fe983a-9d81-4b36-b832-863134769ec2


https://github.com/user-attachments/assets/e1e79f32-44a1-47bc-8efc-92c1096de305


https://github.com/user-attachments/assets/0f79927f-7e23-4f3d-825a-175aba8d3c6c



