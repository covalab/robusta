"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[695],{3905:(e,t,r)=>{r.d(t,{Zo:()=>c,kt:()=>b});var n=r(7294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function i(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?i(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function u(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},i=Object.keys(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)r=i[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var s=n.createContext({}),l=function(e){var t=n.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},c=function(e){var t=l(e.components);return n.createElement(s.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},f=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,i=e.originalType,s=e.parentName,c=u(e,["components","mdxType","originalType","parentName"]),p=l(r),f=a,b=p["".concat(s,".").concat(f)]||p[f]||d[f]||i;return r?n.createElement(b,o(o({ref:t},c),{},{components:r})):n.createElement(b,o({ref:t},c))}));function b(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var i=r.length,o=new Array(i);o[0]=f;var u={};for(var s in t)hasOwnProperty.call(t,s)&&(u[s]=t[s]);u.originalType=e,u[p]="string"==typeof e?e:a,o[1]=u;for(var l=2;l<i;l++)o[l]=r[l];return n.createElement.apply(null,o)}return n.createElement.apply(null,r)}f.displayName="MDXCreateElement"},332:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>s,contentTitle:()=>o,default:()=>d,frontMatter:()=>i,metadata:()=>u,toc:()=>l});var n=r(7462),a=(r(7294),r(3905));const i={id:"flutter-robusta-hive-auth",title:"Flutter Robusta Hive Auth",sidebar_position:8},o=void 0,u={unversionedId:"extensions/flutter-robusta-hive-auth",id:"extensions/flutter-robusta-hive-auth",title:"Flutter Robusta Hive Auth",description:"Prerequites \ud83d\udcdd",source:"@site/docs/extensions/flutter-robusta-hive-auth.md",sourceDirName:"extensions",slug:"/extensions/flutter-robusta-hive-auth",permalink:"/docs/extensions/flutter-robusta-hive-auth",draft:!1,editUrl:"https://github.com/covalab/robusta/edit/main/website/docs/extensions/flutter-robusta-hive-auth.md",tags:[],version:"current",lastUpdatedBy:"Minh Vuong",lastUpdatedAt:1684497337,formattedLastUpdatedAt:"May 19, 2023",sidebarPosition:8,frontMatter:{id:"flutter-robusta-hive-auth",title:"Flutter Robusta Hive Auth",sidebar_position:8},sidebar:"tutorialSidebar",previous:{title:"Flutter Robusta Hive",permalink:"/docs/extensions/flutter-robusta-hive"},next:{title:"Flutter Robusta GraphQL",permalink:"/docs/extensions/flutter-robusta-graphql"}},s={},l=[{value:"Prerequites \ud83d\udcdd",id:"prerequites-",level:3},{value:"Installing \u2699\ufe0f",id:"installing-\ufe0f",level:3},{value:"Usage",id:"usage",level:3},{value:"API",id:"api",level:3}],c={toc:l},p="wrapper";function d(e){let{components:t,...r}=e;return(0,a.kt)(p,(0,n.Z)({},c,r,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h3",{id:"prerequites-"},"Prerequites \ud83d\udcdd"),(0,a.kt)("h3",{id:"installing-\ufe0f"},"Installing \u2699\ufe0f"),(0,a.kt)("h3",{id:"usage"},"Usage"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-js"},"import 'package:flutter_robusta/flutter_robusta.dart';\nimport 'package:flutter_robusta_auth/flutter_robusta_auth.dart';\nimport 'package:flutter_robusta_hive/flutter_robusta_hive.dart';\nimport 'package:flutter_robusta_hive_auth/flutter_robusta_hive_auth.dart';\n\nfinal runner = Runner(\n  extensions: [\n    FlutterHiveExtension(),\n    FlutterHiveAuthExtension(),\n    FlutterAuthExtension(\n      identityProvider: (credentials, provider) => throw UnimplementedError(),\n      credentialsStorageFactory: (c) => c.read(credentialsHiveStorageProvider),\n    )\n  ],\n);\n\nFuture<void> main() => runner.run();\n")),(0,a.kt)("h3",{id:"api"},"API"))}d.isMDXComponent=!0}}]);