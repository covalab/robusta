"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[813],{3905:(e,t,r)=>{r.d(t,{Zo:()=>c,kt:()=>f});var n=r(7294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function i(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function s(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var u=n.createContext({}),l=function(e){var t=n.useContext(u),r=t;return e&&(r="function"==typeof e?e(t):i(i({},t),e)),r},c=function(e){var t=l(e.components);return n.createElement(u.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},b=n.forwardRef((function(e,t){var r=e.components,o=e.mdxType,a=e.originalType,u=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),p=l(r),b=o,f=p["".concat(u,".").concat(b)]||p[b]||d[b]||a;return r?n.createElement(f,i(i({ref:t},c),{},{components:r})):n.createElement(f,i({ref:t},c))}));function f(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=r.length,i=new Array(a);i[0]=b;var s={};for(var u in t)hasOwnProperty.call(t,u)&&(s[u]=t[u]);s.originalType=e,s[p]="string"==typeof e?e:o,i[1]=s;for(var l=2;l<a;l++)i[l]=r[l];return n.createElement.apply(null,i)}return n.createElement.apply(null,r)}b.displayName="MDXCreateElement"},4062:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>u,contentTitle:()=>i,default:()=>d,frontMatter:()=>a,metadata:()=>s,toc:()=>l});var n=r(7462),o=(r(7294),r(3905));const a={id:"robusta-dio",title:"Robusta Dio",sidebar_position:4},i=void 0,s={unversionedId:"extensions/robusta-dio",id:"extensions/robusta-dio",title:"Robusta Dio",description:"Prerequites \ud83d\udcdd",source:"@site/docs/extensions/robusta-dio.md",sourceDirName:"extensions",slug:"/extensions/robusta-dio",permalink:"/docs/extensions/robusta-dio",draft:!1,editUrl:"https://github.com/covalab/robusta/edit/main/website/docs/extensions/robusta-dio.md",tags:[],version:"current",lastUpdatedBy:"Minh Vuong",lastUpdatedAt:1684497337,formattedLastUpdatedAt:"May 19, 2023",sidebarPosition:4,frontMatter:{id:"robusta-dio",title:"Robusta Dio",sidebar_position:4},sidebar:"tutorialSidebar",previous:{title:"Robusta Events",permalink:"/docs/extensions/robusta-events"},next:{title:"Flutter Robusta",permalink:"/docs/extensions/flutter-robusta"}},u={},l=[{value:"Prerequites \ud83d\udcdd",id:"prerequites-",level:3},{value:"Installing \u2699\ufe0f",id:"installing-\ufe0f",level:3},{value:"Usage",id:"usage",level:3},{value:"API",id:"api",level:3}],c={toc:l},p="wrapper";function d(e){let{components:t,...r}=e;return(0,o.kt)(p,(0,n.Z)({},c,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h3",{id:"prerequites-"},"Prerequites \ud83d\udcdd"),(0,o.kt)("h3",{id:"installing-\ufe0f"},"Installing \u2699\ufe0f"),(0,o.kt)("h3",{id:"usage"},"Usage"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-js"},"import 'package:robusta_dio/robusta_dio.dart';\nimport 'package:robusta_runner/robusta_runner.dart';\n\nfinal runner = Runner(\n  extensions: [\n    ImplementingCallbackExtension(),\n    DioExtension(\n      baseOptions: BaseOptions(),\n      interceptorFactories: [\n        (c) => InterceptorsWrapper(),\n      ],\n      transformerFactory: (c) => BackgroundTransformer(),\n      httpClientAdapterFactory: (c) => HttpClientAdapter(),\n    ),\n  ],\n);\n\nFuture<void> main() => runner.run();\n")),(0,o.kt)("h3",{id:"api"},"API"))}d.isMDXComponent=!0}}]);