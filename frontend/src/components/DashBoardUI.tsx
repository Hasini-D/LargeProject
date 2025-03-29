import IconUI from "./IconsUI";
import React, { useState } from "react";
function DashboardUI() {
    const [showPopup, setShowPopup] = useState(false);
    const [gender, setGender] = useState("");
    const [height, setHeight] = useState("");
    const [weight, setWeight] = useState("");
    const [age, setAge] = useState("");
    const [goal, setGoal] = useState("");

    // async function WorkoutPLan() 
    // {
    // }

    return (
        <div className="h-screen bg-white flex flex-col">
            {/* Top Bar */}
            <IconUI/>
            <div className="fmin-h-screen flex flex-col">
                <div className="text-center">
                    <h1 className="text-4xl font-bold text-[#0f172a]">Dashboard</h1>
                </div>
                    
                <div className="flex flex-1 flex-col items-center justify-center space-y-2">         
                    <button 
                        onClick={() => setShowPopup(true)}
                        className="mt-30 w-64 text-center bg-[#0f172a] text-white py-2 rounded-full hover:bg-[#2563eb] transition"
                        >
                        + Add New Workout Plan
                    </button>
                    {showPopup && (
                        <div className="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
                        
                            {/* POPUP CARD */}
                            <div className="bg-white w-full max-w-md rounded-lg shadow-lg p-6 relative">
                                <button
                                onClick={() => setShowPopup(false)}
                                className="absolute top-2 right-3 text-gray-500 hover:text-red-500 text-xl font-bold"
                                >
                            
                                </button>
                                <h2 className="text-2xl font-bold mb-4 text-[#0f172a] text-center">New Workout Plan</h2>
                                <div className="space-y-3">
                                <input
                                    type="text"
                                    placeholder="Gender"
                                    value={gender}
                                    onChange={(e) => setGender(e.target.value)}
                                    className="w-full p-2 border rounded"
                                />
                                <input
                                    type="number"
                                    placeholder="Height (inches)"
                                    value={height}
                                    onChange={(e) => setHeight(e.target.value)}
                                    className="w-full p-2 border rounded"
                                />
                                <input
                                    type="number"
                                    placeholder="Weight (lbs)"
                                    value={weight}
                                    onChange={(e) => setWeight(e.target.value)}
                                    className="w-full p-2 border rounded"
                                />
                                <input
                                    type="number"
                                    placeholder="Age"
                                    value={age}
                                    onChange={(e) => setAge(e.target.value)}
                                    className="w-full p-2 border rounded"
                                />
                                <select
                                    value={goal}
                                    onChange={(e) => setGoal(e.target.value)}
                                    className="w-full p-2 border rounded"
                                >
                                    <option value="">Select a goal</option>
                                    <option value="Lose weight">Lose weight</option>
                                    <option value="Gain weight">Gain weight</option>
                                    <option value="Maintain Weight">Maintain Weight</option>
                                </select>
                                </div>
                                <button 
                                    className="w-full mt-4 bg-[#0f172a] text-white py-2 rounded hover:bg-[#1e293b] transition"
                                >
                                    Submit
                                </button>
                            </div>
                        </div>
                    )}
                     <div className="flex-1 outline-2 h-96 w-96 p-4 bg-white text-center content-center">
                    <h1 className="text-4xl font-bold text-[#0f172a]">Today's Plan</h1>
                </div>
                </div>
            </div>
        </div>
    );
}
export default DashboardUI;