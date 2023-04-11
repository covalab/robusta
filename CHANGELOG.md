# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2023-04-11

### Changes

---

Packages with breaking changes:

 - [`flutter_robusta` - `v0.2.0`](#flutter_robusta---v020)
 - [`flutter_robusta_auth` - `v0.1.0`](#flutter_robusta_auth---v010)
 - [`flutter_robusta_hive` - `v0.1.0`](#flutter_robusta_hive---v010)

Packages with other changes:

 - [`flutter_robusta_graphql` - `v0.1.1`](#flutter_robusta_graphql---v011)
 - [`flutter_robusta_hive_auth` - `v0.1.1`](#flutter_robusta_hive_auth---v011)
 - [`robusta_events` - `v0.2.1`](#robusta_events---v021)
 - [`robusta_runner` - `v0.2.0+1`](#robusta_runner---v0201)

Packages with dependency updates only:

> Packages listed below depend on other packages in this workspace that have had changes. Their versions have been incremented to bump the minimum dependency versions of the packages they depend upon in this project.

 - `robusta_runner` - `v0.2.0+1`

---

#### `flutter_robusta` - `v0.2.0`

 - **FIX**: lint rules. ([b74c3e18](https://github.com/covalab/robusta/commit/b74c3e18a6c57ed9851498d431d02c3a11c630b7))
 - **FIX**: lint. ([19fe2c5c](https://github.com/covalab/robusta/commit/19fe2c5c76e484c633a98d825e1840c7fa115986))
 - **FEAT**: bump packages dependencies. ([11c2dafc](https://github.com/covalab/robusta/commit/11c2dafcafbfd6032f467baf5446767d1151f2fe))
 - **FEAT**: prevent extends base classes. ([cdb40787](https://github.com/covalab/robusta/commit/cdb4078729e798d1beb961081d2e9d1abdd1a6f6))
 - **FEAT**: simplify app extension. ([2857727a](https://github.com/covalab/robusta/commit/2857727ad0c8e3c26a72f06b2162cff22509097e))
 - **FEAT**: package initial. ([d2114a25](https://github.com/covalab/robusta/commit/d2114a25622241ad0b727f94b2146558fb5f75de))
 - **FEAT**: bump flutter_robusta to 0.1.0. ([4fe11769](https://github.com/covalab/robusta/commit/4fe117693858d6d24350db51ab8cb533d6f4d0db))
 - **DOCS**: fix typo. ([c2eabd47](https://github.com/covalab/robusta/commit/c2eabd475fb993de567f044997ba01f021ac23d8))
 - **DOCS**: update CHANGELOG. ([ea9c4480](https://github.com/covalab/robusta/commit/ea9c44800bfb4fceb827cc83410a4ded982e632e))
 - **DOCS**: add README to robusta_runner and flutter_robusta. ([fed7b154](https://github.com/covalab/robusta/commit/fed7b1541509a51b96f8ee3044ee9be4d4a5cbb8))
 - **BREAKING** **FEAT**: improve error handling. ([2abb2014](https://github.com/covalab/robusta/commit/2abb2014b0a1e86e395ce079ada13c8e417eed11))
 - **BREAKING** **FEAT**: rename AppExtension to FlutterAppExtension. ([747ae0c0](https://github.com/covalab/robusta/commit/747ae0c09e5772112c0bcf56a03cbe0f3cd11054))

#### `flutter_robusta_auth` - `v0.1.0`

 - **FIX**: test. ([0882cfa7](https://github.com/covalab/robusta/commit/0882cfa7bc0ccc0e48186ddc3d66d25f12c4790f))
 - **FEAT**: uses generic arg to define screen access. ([dee2c480](https://github.com/covalab/robusta/commit/dee2c48041c48a2c7442e8ffa27e4541b526c8b6))
 - **FEAT**: add access manager. ([b1d93223](https://github.com/covalab/robusta/commit/b1d93223716492b783a23be67dafbe546031925b))
 - **FEAT**: add screen access control. ([ff621447](https://github.com/covalab/robusta/commit/ff621447ceb9c6dc4b74dc92b4a0b81a43283da3))
 - **FEAT**: authz for extension. ([d74685eb](https://github.com/covalab/robusta/commit/d74685eb79271747f1f41676e1a99600a3c3e138))
 - **FEAT**: authz for identity. ([0c50b8d1](https://github.com/covalab/robusta/commit/0c50b8d192baffc88906e4eee8259e26b35db359))
 - **FEAT**: add authz. ([7bf08ebb](https://github.com/covalab/robusta/commit/7bf08ebbf0137e49c1d04a9255882fd8e1af74c6))
 - **FEAT**: manage credentials by auth service. ([930d956d](https://github.com/covalab/robusta/commit/930d956d929aafe4317b20043fb2f549e3f4dafa))
 - **DOCS**: add readme and example. ([d71e49ea](https://github.com/covalab/robusta/commit/d71e49ea9e53ae938a4192b67330e30c92ffdb7a))
 - **BREAKING** **FEAT**: replace boots arg with defineBoot. ([1067f066](https://github.com/covalab/robusta/commit/1067f0661da855be2e22cfe394460ba739d7c0ff))
 - **BREAKING** **FEAT**: scope less auth manager. ([5d54e942](https://github.com/covalab/robusta/commit/5d54e9427d83407615d8d2cae577b9e70e4845fc))

#### `flutter_robusta_hive` - `v0.1.0`

 - **FEAT**: package initial. ([d2114a25](https://github.com/covalab/robusta/commit/d2114a25622241ad0b727f94b2146558fb5f75de))
 - **BREAKING** **FEAT**: simplify Hive extension. ([40f66167](https://github.com/covalab/robusta/commit/40f661678553e090bc503feb38bf75ce72924bcc))
 - **BREAKING** **FEAT**: improve error handling. ([2abb2014](https://github.com/covalab/robusta/commit/2abb2014b0a1e86e395ce079ada13c8e417eed11))
 - **BREAKING** **FEAT**: normalize builtin extensions. ([09c14b61](https://github.com/covalab/robusta/commit/09c14b6175f6a49d0597d99b1d8cc317c5e62c4a))
 - **BREAKING** **FEAT**: init flutter should be call when boot instead. ([414b308c](https://github.com/covalab/robusta/commit/414b308c1d494b35c08f46e8948ba24fb6f66ef1))

#### `flutter_robusta_graphql` - `v0.1.1`

 - **FEAT**: add flutter_robusta_graphql package. ([d7f595df](https://github.com/covalab/robusta/commit/d7f595dfded4b9df4469f6572b3058e6ee1cce14))
 - **DOCS**: add readme, changelog and example. ([2c2139c1](https://github.com/covalab/robusta/commit/2c2139c14f52233a863eead96b8ed9ca16240189))

#### `flutter_robusta_hive_auth` - `v0.1.1`

 - **FEAT**: add flutter_robusta_hive_auth package. ([717d40f7](https://github.com/covalab/robusta/commit/717d40f7c087e06ce88ad62209ed6d1a3201cc1c))
 - **DOCS**: add example, changelog and readme. ([0873a7cf](https://github.com/covalab/robusta/commit/0873a7cf5b73b5a2115e0ea52f2f2f06e5f93f48))

#### `robusta_events` - `v0.2.1`

 - **FEAT**: bump packages dependencies. ([11c2dafc](https://github.com/covalab/robusta/commit/11c2dafcafbfd6032f467baf5446767d1151f2fe))
