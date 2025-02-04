<h1 align="center">
  <br>
  <a href="https://github.com/spxnso/ElementalUI">
    <img src="https://www.lua.org/images/luaa.gif" alt="ElementalUI" width="200">
  </a>
  <br>
  Elemental UI
  <br>
  <h4 align="center">
    A modern, hot, sexy UI for Roblox exploiting.
    <a href="https://luau.org/" target="_blank">Luau</a>.
  </h4>
</h1>

<p align="center">
  <a href="https://github.com/spxnso/ElementalUI/stargazers">
    <img src="https://img.shields.io/github/stars/spxnso/ElementalUI?color=%232C2D72" alt="Stars">
  </a>
  <a href="https://github.com/spxnso/ElementalUI/readme.md">
    <img src="https://img.shields.io/badge/version-1.0.1-%232C2D72" alt="Version">
  </a>
  <a href="https://github.com/spxnso/ElementalUI/LICENSE">
    <img src="https://img.shields.io/github/license/spxnso/ElementalUI?color=%232C2D72" alt="License">
  </a>
</p>

<p align="center">
  <h4 align="center">
    Enjoyed this project? Consider
    <a href="https://github.com/spxnso/ElementalUI/stargazers">giving us a star</a> ⭐ on GitHub!
  </h4>
</p>

<h4 align="left">
  <details open="open">
    <summary>Table of Contents</summary>
    <ul>
      <li><a href="#updates">Updates</a>
      <li><a href="#about">About</a>
        <ul>
          <li><a href="#built-with">Built with</a></li>
        </ul>
      </li>
      <li><a href="#getting-started">Getting Started</a>
        <ul>
          <li><a href="#prerequisites">Prerequisites</a></li>
          <li><a href="#usage">How to Use</a></li>
          <li><a href="#options">Available Options</a></li>
        </ul>
      </li>
      <li><a href="#license">License</a></li>
    </ul>
  </details>
</h4>

---

## About

<table>
  <tr>
    <td>
      ElementalUI is a UI library designed for Roblox exploit scripts, providing an intuitive and customizable interface.
    </td>
  </tr>
</table>

### Built with:
- [Luau](https://luau.org/)
- [Love ❤️](https://c.tenor.com/kq7GyBPPIj0AAAAd/tenor.gif)
- [Knowledge 🎓](https://chatgpt.com)


## Getting Started

### Prerequisites

1. Roblox executor.
2. Atleast 2 braincells.

### Usage

1. In order to get started with ElementalUI, run the following script:
   ```lua
   local Elemental = loadstring(game:HttpGet("https://raw.githubusercontent.com/spxnso/ElementalUI/refs/heads/main/source.lua"))()
   local Window = Elemental:New({
         UITitle = string.upper("elemental"),
         DefaultTheme = "Dark" -- or Light
   })```

### Options
1. Create a Tab
   ```lua
   local Tab = Window:Tab("Main")
   ```
2. Read the example code

## License

This project is licensed under the **MIT license**.
See [LICENSE](LICENSE) for more information.
