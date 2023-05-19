import React from "react";
import clsx from "clsx";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import HomepageFeatures from "../components/HomePageFeatures";

import styles from "./index.module.css";
import { useColorMode } from "@docusaurus/theme-common";

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx("hero hero--primary", styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">{siteConfig.title}</h1>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/docs/intro"
          >
            Get Started
          </Link>
        </div>
      </div>
    </header>
  );
}

function HomePageMainContent() {
  const { colorMode, setColorMode } = useColorMode();
  const { siteConfig } = useDocusaurusContext();

  return (
    <div className={`flex justify-center items-center p-16 w-full h-full`}>
      <div className="w-2/6 ">
        <div className="flex">
          <img
            className="w-12 h-9"
            src="../img/coffee-bean-icon.png"
            alt="site-logo"
          />
          <h1 className="mx-2">{siteConfig.title}</h1>
        </div>
        <h1 className="py-10">{siteConfig.tagline}</h1>
        <div
          className={`rounded ${
            colorMode === "light" ? "bg-primary-700" : "bg-lightPrimary-700"
          } text-center 
                     text-lg font-bold  my-2 mx-10 ${
                       colorMode === "light"
                         ? "shadow-primary-700"
                         : "shadow-lightPrimary-700"
                     }  shadow-md`}
        >
          <Link to="/docs/intro" className="text-white">
            <h3 className="p-2">Get Started</h3>
          </Link>
        </div>
      </div>

      <div className="w-full p-4 flex justify-end">
        <img
          src="https://github.com/qu0cquyen/robusta/assets/28641819/b36e54b9-602f-4b19-aa56-8a488692bf0e
"
          alt="hello_robusta"
        />
      </div>
    </div>
  );
}

export default function Home(): JSX.Element {
  return (
    <Layout description="Description will go into a meta tag in <head />">
      {/* <HomepageHeader /> */}
      {/* <main><HomepageFeatures /></main> */}
      <HomePageMainContent />
    </Layout>
  );
}
