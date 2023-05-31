"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[299],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>b});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)n=o[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var s=r.createContext({}),p=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},u=function(e){var t=p(e.components);return r.createElement(s.Provider,{value:t},e.children)},c="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,o=e.originalType,s=e.parentName,u=i(e,["components","mdxType","originalType","parentName"]),c=p(n),m=a,b=c["".concat(s,".").concat(m)]||c[m]||d[m]||o;return n?r.createElement(b,l(l({ref:t},u),{},{components:n})):r.createElement(b,l({ref:t},u))}));function b(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=n.length,l=new Array(o);l[0]=m;var i={};for(var s in t)hasOwnProperty.call(t,s)&&(i[s]=t[s]);i.originalType=e,i[c]="string"==typeof e?e:a,l[1]=i;for(var p=2;p<o;p++)l[p]=n[p];return r.createElement.apply(null,l)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},2333:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>s,contentTitle:()=>l,default:()=>d,frontMatter:()=>o,metadata:()=>i,toc:()=>p});var r=n(7462),a=(n(7294),n(3905));const o={id:"robusta-cli",title:"Robusta Command Line",sidebar_position:4},l=void 0,i={unversionedId:"robusta-cli",id:"robusta-cli",title:"Robusta Command Line",description:"1. Add",source:"@site/docs/robusta-cli.md",sourceDirName:".",slug:"/robusta-cli",permalink:"/docs/robusta-cli",draft:!1,editUrl:"https://github.com/covalab/robusta/edit/main/website/docs/robusta-cli.md",tags:[],version:"current",lastUpdatedBy:"Minh Vuong",lastUpdatedAt:1685548768,formattedLastUpdatedAt:"May 31, 2023",sidebarPosition:4,frontMatter:{id:"robusta-cli",title:"Robusta Command Line",sidebar_position:4},sidebar:"tutorialSidebar",previous:{title:"Customize Extension",permalink:"/docs/customize-extension"},next:{title:"Extensions",permalink:"/docs/category/extensions"}},s={},p=[{value:"1. Add",id:"1-add",level:3},{value:"2. Gen",id:"2-gen",level:3},{value:"3. New",id:"3-new",level:3},{value:"4. Self-update",id:"4-self-update",level:3},{value:"5. Version",id:"5-version",level:3}],u={toc:p},c="wrapper";function d(e){let{components:t,...n}=e;return(0,a.kt)(c,(0,r.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h3",{id:"1-add"},"1. Add"),(0,a.kt)("p",null,"Not all the extensions are added by defult. The following command helps us quickly add any available extensions"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"robusta add [extension_name]\n")),(0,a.kt)("p",null,(0,a.kt)("img",{parentName:"p",src:"https://github.com/qu0cquyen/robusta/assets/28641819/58b77a11-7d47-4aee-9956-becd75c624a3",alt:"add-command"})),(0,a.kt)("h3",{id:"2-gen"},"2. Gen"),(0,a.kt)("p",null,(0,a.kt)("strong",{parentName:"p"},"Robusta")," also supports generating boilerplate code."),(0,a.kt)("p",null,"Current ",(0,a.kt)("strong",{parentName:"p"},"Robusta")," offers 2 types of generation:"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Repository"),(0,a.kt)("li",{parentName:"ul"},"Screen")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"robusta generate [type] [name]\n")),(0,a.kt)("p",null,(0,a.kt)("img",{parentName:"p",src:"https://github.com/qu0cquyen/robusta/assets/28641819/8f630372-a841-4c1f-a75d-cf00ca4023ae",alt:"generate-command"})),(0,a.kt)("p",null,"When generating ",(0,a.kt)("strong",{parentName:"p"},"Repository"),", you can choose either ",(0,a.kt)("inlineCode",{parentName:"p"},"GraphQL")," or ",(0,a.kt)("inlineCode",{parentName:"p"},"Dio")," to suit your usecase."),(0,a.kt)("p",null,"Similar to ",(0,a.kt)("strong",{parentName:"p"},"Repository"),", ",(0,a.kt)("strong",{parentName:"p"},"Screen")," will also give you 2 options to choose from: ",(0,a.kt)("inlineCode",{parentName:"p"},"Normal")," and ",(0,a.kt)("inlineCode",{parentName:"p"},"Shell")),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"Shell")," screen is basically a big wrapper for any subscreens inside."),(0,a.kt)("admonition",{type:"info"},(0,a.kt)("p",{parentName:"admonition"},"You can think ",(0,a.kt)("inlineCode",{parentName:"p"},"Shell")," screen is just like ",(0,a.kt)("inlineCode",{parentName:"p"},"Fragments")," in Android, or ",(0,a.kt)("inlineCode",{parentName:"p"},"Layout")," - ","[Header and Footer]"," in Web")),(0,a.kt)("h3",{id:"3-new"},"3. New"),(0,a.kt)("p",null,"To create a completely new flutter Project"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"robusta new [project name]\n")),(0,a.kt)("p",null,(0,a.kt)("img",{parentName:"p",src:"https://github.com/qu0cquyen/robusta/assets/28641819/b36e54b9-602f-4b19-aa56-8a488692bf0e",alt:"hello_robusta"})),(0,a.kt)("h3",{id:"4-self-update"},"4. Self-update"),(0,a.kt)("p",null,"Update new version of ",(0,a.kt)("strong",{parentName:"p"},"Robusta CLI")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"robusta self-update\n")),(0,a.kt)("h3",{id:"5-version"},"5. Version"),(0,a.kt)("p",null,"Check the current version of ",(0,a.kt)("strong",{parentName:"p"},"Roubusta CLI")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"robusta version\n")))}d.isMDXComponent=!0}}]);