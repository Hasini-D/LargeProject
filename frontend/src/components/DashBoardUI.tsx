import { useState, useMemo, useEffect } from "react";
import Calendar from "react-calendar";
import "react-calendar/dist/Calendar.css";
import IconUI from "./IconsUI";

type DayStatus = "none" | "workout" | "rest" | "missed";

// calendar UI, get the streak from each day, and get the workout for each day
function CalendarUI() {
  const userData = localStorage.getItem('user_data');
  const user = userData ? JSON.parse(userData) : null;
  const username = user?.login || "User";
  const userGoal = user?.goal || "Maintain Weight";

  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [dayData, setDayData] = useState<Record<string, DayStatus>>({});
  const formatDate = (date: Date) => date.toDateString();
  const selectedStatus = dayData[formatDate(selectedDate)] || "none";

  // Dynamically set workouts based on user's goal
  const workoutPlan: Record<string, string> = useMemo(() => {
    if (userGoal === "Lose Weight") {
      return {
        "Squats": "3x10",
        "Bench Press": "3x8",
        "Deadlift": "3x8",
        "Running": "3 miles",
      };
    } else if (userGoal === "Weight Gain/Muscle Build") {
      return {
        "Squats": "4x8",
        "Bench Press": "4x8",
        "Deadlift": "4x8",
        "Running": "1 mile",
      };
    } else {
      // Default: Maintain Weight
      return {
        "Squats": "3x12",
        "Bench Press": "3x12",
        "Deadlift": "3x12",
        "Running": "2 miles",
      };
    }
  }, [userGoal]);

  // Rotate through workouts by day of week
  const workoutKeys = Object.keys(workoutPlan);
  const selectedWorkout = workoutKeys[selectedDate.getDay() % workoutKeys.length];
  const workoutDetails = workoutPlan[selectedWorkout];

  const handleStatusChange = (value: DayStatus) => {
    const key = formatDate(selectedDate);
    setDayData((prev) => ({ ...prev, [key]: value }));
  };

  const streak = useMemo(() => {
    let count = 0;
    const sortedDates = Object.keys(dayData)
      .filter((key) => ["workout", "rest", "missed"].includes(dayData[key]))
      .map((key) => new Date(key))
      .sort((a, b) => b.getTime() - a.getTime());

    for (let date of sortedDates) {
      const key = formatDate(date);
      const status = dayData[key];
      if (status === "workout" || status === "rest") {
        if (status === "workout") count++;
      } else {
        break;
      }
    }
    return count;
  }, [dayData]);

  // Styling for calendar
  useEffect(() => {
    const style = document.createElement("style");
    style.innerHTML = `
      .react-calendar {
        border-radius: 1rem;
        overflow: hidden;
        border: none;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        background-color: #e0f2ff;
        color: #1e3a8a;
      }

      .react-calendar__navigation {
        background-color: #3b82f6;
      }

      .react-calendar__navigation button {
        color: white;
        font-weight: bold;
        border-radius: 0.5rem;
        margin: 0 2px;
      }

      .react-calendar__navigation button:enabled:hover {
        background-color: #2563eb;
      }

      .react-calendar__tile {
        border-radius: 0.75rem;
        background-color: #f0f9ff;
        transition: background-color 0.2s ease;
      }

      .react-calendar__tile:enabled:hover,
      .react-calendar__tile:enabled:focus {
        background-color: #cfe8ff;
      }

      .react-calendar__tile--now {
        background: #93c5fd !important;
        color: white;
        border-radius: 9999px;
      }

      .react-calendar__tile--active {
        background: #3b82f6 !important;
        color: white;
      }
    `;
    document.head.appendChild(style);
    return () => {
      document.head.removeChild(style);
    };
  }, []);

  return (
    <div className="h-screen bg-gradient-to-br from-[#e0f7f4] via-[#f2fdfc] to-[#ffffff] flex flex-col">
      {/* Top Navigation */}
      <IconUI />

      {/* 3-Column Flex Layout */}
      <div className="flex flex-1 mt-24 px-8">
        {/* Calendar (Left) */}
        <div className="w-1/3 flex justify-center items-start">
          <div className="max-w-[500px] scale-[1.4]">
            <h2 className="text-2xl font-semibold text-[#0f172a] mb-4 ml-2">
              Welcome, {username}
            </h2>
            <Calendar
              onChange={(value) => setSelectedDate(value as Date)}
              value={selectedDate}
            />
          </div>
        </div>

        {/* Streak + Buttons (Center) */}
        <div className="w-1/3 flex flex-col items-center justify-start mt-[-60px]">
          <h2 className="text-2xl font-bold text-[#0f172a] mb-6">
            🔥 Streak: {streak} day{streak !== 1 ? "s" : ""}
          </h2>
          <div className="flex flex-col gap-4 mt-25">
            <button
              onClick={() => handleStatusChange("workout")}
              className={`px-4 py-2 rounded transition duration-300 active:scale-95 ${
                selectedStatus === "workout"
                  ? "bg-blue-500 text-white"
                  : "bg-gray-200 text-[#0f172a] hover:bg-blue-100"
              }`}
            >
              🏋️ Workout
            </button>
            <button
              onClick={() => handleStatusChange("rest")}
              className={`px-4 py-2 rounded transition duration-300 active:scale-95 ${
                selectedStatus === "rest"
                  ? "bg-blue-500 text-white"
                  : "bg-gray-200 text-[#0f172a] hover:bg-blue-100"
              }`}
            >
              😌 Rest
            </button>
            <button
              onClick={() => handleStatusChange("missed")}
              className={`px-4 py-2 rounded transition duration-300 active:scale-95 ${
                selectedStatus === "missed"
                  ? "bg-blue-500 text-white"
                  : "bg-gray-200 text-[#0f172a] hover:bg-blue-100"
              }`}
            >
              ❌ Missed
            </button>
          </div>
        </div>

        {/* To Do (Right) */}
        <div className="w-1/3 pl-8">
          <h3 className="text-2xl font-bold text-[#0f172a] mb-4">📋 To Do:</h3>
          <p className="text-lg text-[#0f172a] mb-2">
            <strong>Workout:</strong> {selectedWorkout} - {workoutDetails}
          </p>
          {selectedStatus !== "none" && (
            <p className="text-sm text-gray-500 italic">
              Status for {formatDate(selectedDate)}: {selectedStatus}
            </p>
          )}
        </div>
      </div>
    </div>
  );
}

export default CalendarUI;
