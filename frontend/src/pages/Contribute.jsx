import React, { useEffect, useRef } from 'react';
import './Contribute.css';

const Contribute = () => {
  const cardRefs = useRef([]);
  
  useEffect(() => {
  const currentRefs = cardRefs.current;
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("slide-down"); // <-- change here
        }
      });
    },
    { threshold: 0.1 }
  );

  currentRefs.forEach((ref) => {
    if (ref) observer.observe(ref);
  });

  return () => {
    currentRefs.forEach((ref) => {
      if (ref) observer.unobserve(ref);
    });
  };
}, []);

  const contributionSteps = [
    {
      title: 'Fork the Repository',
      description: 'Start by forking the UniFix repository to your own GitHub account. This creates a copy of the repository under your account that you can modify.',
      code: 'git clone https://github.com/Yash09042004/UniFix.git'
    },
    {
      title: 'Make Changes',
      description: 'Add new scripts, fix bugs, or improve existing functionality. Make sure to follow the project guidelines and coding standards.',
      code: 'cd UniFix\n# Make your changes to the codebase'
    },
    {
      title: 'Add Scripts',
      description: 'When adding new scripts, place them in the appropriate category folder and update the corresponding component file.',
      code: '# Create your script file\ntouch public/scripts/Your_Script_Name.sh\n\n# Update CategoryPage.js with your script details'
    },
    {
      title: 'Test Locally',
      description: 'Test your changes locally to ensure everything works as expected before submitting.',
      code: 'npm install\nnpm start\n\n# In a separate terminal\ncd backend\nnpm install\nnpm start'
    },
    {
      title: 'Push Changes',
      description: 'Commit and push your changes to your forked repository.',
      code: 'git add .\ngit commit -m "Add description of your changes"\ngit push origin main'
    },
    {
      title: 'Create Pull Request',
      description: 'Submit a pull request from your fork to the original UniFix repository. Provide a clear description of your changes.',
      code: '# Go to https://github.com/Yash09042004/UniFix\n# Click "New Pull Request"\n# Select your fork and branch\n# Submit the pull request'
    }
  ];

  return (
    <div className="contribute-container">
      <h1 className="contribute-title">How to Contribute</h1>
      <p className="contribute-subtitle">Follow these steps to contribute to our project</p>
      
      <div className="contribution-steps-container">
        {contributionSteps.map((step, index) => (
          <div 
            key={index} 
            className="contribution-card"
            ref={el => cardRefs.current[index] = el}
          >
            <h3 className="contribution-title">{step.title}</h3>
            <p className="contribution-description">{step.description}</p>
            <div className="contribution-code-block">
              <pre>{step.code}</pre>
            </div>
            <div className="step-number">{index + 1}</div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Contribute;
