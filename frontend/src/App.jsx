import React from 'react'
import { Route, Routes } from 'react-router-dom'
import Home from './pages/Home'
import Domains from './pages/Domains'
import Feedback from './pages/Feedback'
import ViewFeedback from './pages/ViewFeedback'
import Contribute from './pages/Contribute'
import CategoryPage from './pages/CategoryPage'
import Navbar from './components/Navbar'
import './App.css'

function App() {
  return (
    <>
      <Navbar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/domains" element={<Domains />} />
        <Route path="/feedback" element={<Feedback />} />
        {/* Uncomment if needed */}
        {/* <Route path="/view-feedback" element={<ViewFeedback />} /> */}
        <Route path="/contribute" element={<Contribute />} />
        <Route path="/domains/:category" element={<CategoryPage />} />
      </Routes>
    </>
  )
}

export default App
