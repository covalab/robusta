---
id: robusta-cli
title: Robusta Command Line
sidebar_position: 4
---

### 1. Add

Not all the extensions are added from **Robusta** app creation command line. The following command helps us quickly add any available extensions

```sh
robusta add [extension_name]
```
![add-command](https://github.com/qu0cquyen/robusta/assets/28641819/58b77a11-7d47-4aee-9956-becd75c624a3)

### 2. Gen

**Robusta** also support generating boilerplate code.

Current **Robusta** offers 2 types of generation:

- Repository
- Screen

```sh
robusta generate [type] [name]
```

![generate-command](https://github.com/qu0cquyen/robusta/assets/28641819/8f630372-a841-4c1f-a75d-cf00ca4023ae)

When generating **Repository**, you can choose either `GraphQL` or `Dio` to suit your usecase.

Similar to **Repository**, **Screen** will also give you 2 options to choose from: `Normal` and `Shell`

`Shell` screen is basically a big wrapper for any subscreens inside.

:::info
You can think `Shell` screen is just like `Fragments` in Android, or `Layout` - [Header and Footer] in Web
:::

### 3. New

To create a completely new flutter Project

```sh
robusta new [project name]
```

![hello_robusta](https://github.com/qu0cquyen/robusta/assets/28641819/b36e54b9-602f-4b19-aa56-8a488692bf0e)

### 4. Self-update

Update new version of **Robusta CLI**

```sh
robusta self-update
```

### 5. Version

Check the current version of **Roubusta CLI**

```sh
robusta version
```
