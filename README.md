<div align="center">

![mirrord logo dark](./images/logo_dark.png#gh-dark-mode-only)

</div>

<div align="center">

![mirrord logo light](./images/logo_light.png#gh-light-mode-only)

</div>

[![Discord](https://img.shields.io/discord/933706914808889356?color=5865F2&label=Discord&logo=discord&logoColor=white)](https://discord.gg/J5YSrStDKD)
![License](https://img.shields.io/badge/license-MIT-green)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/metalbear-co/mirrord)
[![Twitter Follow](https://img.shields.io/twitter/follow/metalbearco?style=social)](https://twitter.com/metalbearco)

mirrord lets developers run local processes in the context of their cloud environment.
It’s meant to provide the benefits of running your service on a cloud environment (e.g. staging) without actually
going through the hassle of deploying it there, and without disrupting the environment by deploying untested code.
It comes as a Visual Studio Code extension, an IntelliJ plugin and a CLI tool. You can read more about it [here](https://mirrord.dev/docs/overview/introduction/).

# Contents

- [Contents](#contents)
  - [Getting Started](#getting-started)
  - [VS Code Extension](#vs-code-extension)
    - [Installation](#installation)
    - [How To Use](#how-to-use)
  - [IntelliJ Plugin](#intellij-plugin)
    - [Installation](#installation-1)
    - [How To Use](#how-to-use-1)
  - [CLI Tool](#cli-tool)
    - [Installation](#installation-2)
    - [How To Use](#how-to-use-2)
  - [How It Works](#how-it-works)
  - [FAQ](#faq)
  - [Contributing](#contributing)
  - [Development](#development)
  - [Help and Community](#help-and-community)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

---

## Getting Started

- [VS Code Extension](#vs-code-extension)
- [IntelliJ Plugin](#intellij-plugin)
- [CLI Tool](#cli-tool)

> mirrord uses your machine's default kubeconfig for access to the Kubernetes API.

---

## VS Code Extension

### Installation

Get the extension [here](https://marketplace.visualstudio.com/items?itemName=MetalBear.mirrord).

### How To Use

- Click "Enable mirrord" on the status bar
- Start debugging your project
- Choose pod to impersonate
- The debugged process will be plugged into the selected pod by mirrord

<p align="center">
  <img src="./images/vscode.gif">
</p>

---

## IntelliJ Plugin

### Installation

Get the plugin [here](https://plugins.jetbrains.com/plugin/19772-mirrord).

### How To Use

- Click the mirrord icon in the Navigation Toolbar
- Start debugging your project
- Choose a namespace and pod to impersonate
- The debugged process will be plugged into the selected pod by mirrord

<p align="center">
  <img src="./images/intellij.gif">
</p>

---

## CLI Tool

### Installation

```sh
curl -fsSL https://raw.githubusercontent.com/metalbear-co/mirrord/main/scripts/install.sh | bash
```

- Windows isn't currently supported (you can use WSL)

### How To Use

```sh
mirrord exec <process command> --target <target-path>
```

e.g.

```sh
mirrord exec node app.js --target pod/my-pod
```

---

## How It Works

When you select a pod to impersonate, mirrord launches a privileged pod on the same node as the pod you selected.
The new pod is then used to connect your local process and the impersonated pod: it mirrors incoming traffic from the pod to your process,
routes outgoing traffic from your process through the pod, and does the same for file reads, file writes, and environment variables.
You can read more about it [here](https://mirrord.dev/docs/overview/introduction/).

<p align="center">
  <img src="./images/how_it_works.svg" alt="How It Works"/>
</p>

## FAQ

Our FAQ is available [here](https://mirrord.dev/docs/overview/faq/).
If you have a question that's not on there, feel free to ask in our [Discussions](https://github.com/metalbear-co/mirrord/discussions)
or on [Discord](https://discord.gg/J5YSrStDKD).

## Contributing

Contributions are much welcome. Start by checking out [issues](https://github.com/metalbear-co/mirrord/issues).
If you wish to work an issue, please comment so you can be assigned.

## Development

Read our development guide [here](https://mirrord.dev/docs/developer/testing/).

## Help and Community

Join our [Discord Server](https://discord.gg/J5YSrStDKD) for questions, support and fun.

## Code of Conduct

We take our community seriously and we are dedicated to providing a safe and welcoming environment for everyone.
Please take a few minutes to review our [Code of Conduct](./CODE_OF_CONDUCT.md).

## License

[MIT](./LICENSE)
