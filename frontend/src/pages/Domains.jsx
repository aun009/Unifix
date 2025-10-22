import React, { useCallback } from "react";
import { useNavigate } from "react-router-dom";
import Particles from "react-tsparticles";
import { loadFull } from "tsparticles";
import "./Domains.css";

const Domains = () => {
  const navigate = useNavigate();
  const categories = [
    { name: "Memory", image: "https://weishielectronics.com/wp-content/uploads/2024/05/memory-chip-is-hardware-1024x531.webp" },
    { name: "Labs", image: "https://static.vecteezy.com/system/resources/previews/032/939/325/large_2x/futuristic-computer-lab-with-bright-blue-lighting-free-photo.jpg" },
    { name: "Drivers", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRH2MZoYH53RRrm9UvNEBdB4dvpCQRjkqzfg&s" },
    { name: "Tools", image: "https://lib.spline.design/thumbnails/7b184106-4b3e-48cd-8df3-31d61eb5ab2e" },
    { name: "Softwares", image: "https://i.ytimg.com/vi/Om4vQgsyv5c/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDfEnKGnFmzOQ2l85K4kCjd2ksM5Q" },
    { name: "Docker", image: "https://kinsta.com/wp-content/uploads/2023/04/kubernetes-vs-docker.jpg" },
    { name: "Networking", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhx2AFXxfNNZhSyTzWKb-yHPjQY2NT54Smvw&s" },
    { name: "Cloud Computing", image: "https://img.freepik.com/premium-photo/cloud-computing-database-upload-center-hosting-3d-illustration-concept_1995-911.jpg" },
    { name: "Cybersecurity", image: "https://static.vecteezy.com/system/resources/previews/026/564/508/non_2x/cyber-security-information-protect-and-or-safe-concept-abstract-3d-sphere-or-globe-with-surface-of-hexagons-with-lock-icon-illustrates-cyber-data-security-or-network-security-illustration-vector.jpg" },
    { name: "Artificial Intelligence", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTU7tKBVV4s7RstZPvKeJof5M015V0SO_hF-Q&s" },
    { name: "Data Science", image: "https://www.shutterstock.com/image-vector/development-nuclear-atomic-technology-interaction-600nw-1329452954.jpg" },
    { name: "Web Development", image: "https://dxbapps.com/blogimages/web-development.jpg" },
    { name: "Mobile Development", image: "https://img.freepik.com/free-vector/mobile-app-development-isometric-background-with-composition-smartphone-screens-with-3d-app-icons-connections-vector-illustration_1284-77301.jpg?semt=ais_hybrid" },
    { name: "Game Development", image: "https://img.freepik.com/free-psd/vr-video-game-composition_1419-2358.jpg" },
    { name: "DevOps", image: "https://img.freepik.com/free-vector/isometric-devops-illustration_52683-84175.jpg" },
    { name: "Blockchain", image: "https://www.shutterstock.com/image-vector/blockchain-digital-technology-perspective-illustration-600nw-2006044007.jpg" },
    { name: "Unsolved Issues", image: "https://img.freepik.com/free-vector/innovation-concept-illustration_114360-5848.jpg", 
      description: "Innovative solutions to previously unsolved problems" },
  ];

  const particlesInit = useCallback(async (engine) => {
    await loadFull(engine);
  }, []);

  const particlesOptions = {
    background: {
      color: "#1e1f26",
    },
    particles: {
      color: {
        value: ["#03dac6", "#ff0266", "#000000"],
      },
      links: {
        enable: true,
        color: "#ffffff",
        distance: 150,
      },
      move: {
        enable: true,
        speed: 2,
      },
      number: {
        value: 50,
      },
      size: {
        value: 3,
      },
    },
  };

  const handleCategoryClick = (categoryName) => {
    navigate(`/domains/${categoryName.toLowerCase()}`);
  };

  return (
    <div className="domains-page">
      <Particles className="background" init={particlesInit} options={particlesOptions} />
      <h1 className="domains-title">Explore Domains</h1>
      <div className="categories-container">
        {categories.map((category) => (
          <div
            key={category.name}
            className="category-card"
            onClick={() => handleCategoryClick(category.name)}
          >
            <div
              className="category-image"
              style={{ backgroundImage: `url(${category.image})` }}
            ></div>
            <div className="category-overlay">
              <h2 className="category-name">{category.name}</h2>
              {category.description && (
                <p className="category-description">{category.description}</p>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Domains;
