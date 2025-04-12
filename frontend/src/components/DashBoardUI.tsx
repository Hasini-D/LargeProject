import { useState, useEffect } from "react";
import Calendar from "react-calendar";
import "react-calendar/dist/Calendar.css";
import IconUI from "./IconsUI";
import { buildPath } from "./Path"; // Make sure buildPath handles localhost/prod

type DayStatus = "none" | "workout" | "rest" | "missed";

function CalendarUI() {
  const userData = localStorage.getItem("user_data");
  const user = userData ? JSON.parse(userData) : null;
  const username = user?.login || "User";
  const userId = user?.id;

  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [dayData, setDayData] = useState<Record<string, DayStatus>>({});
  const [streak, setStreak] = useState<number>(0);
  const [userGoal, setUserGoal] = useState("Maintain Weight");

  const formatDate = (date: Date) => date.toDateString();
  const selectedStatus = dayData[formatDate(selectedDate)] || "none";

  // get users goal
  useEffect(() => {
    const fetchGoal = async () => {
      if (!userId) return;
      try {
        const res = await fetch(buildPath(`api/get-profile?userId=${userId}`));
        const data = await res.json();
        if (res.ok && data.goal) {
          setUserGoal(data.goal);
        }
      } catch (err) {
        console.error("Failed to fetch goal:", err);
      }
    };
    fetchGoal();
  }, [userId]);
  
  const getWorkoutPlan = (): Record<string, string> => {

    if (userGoal === "Lose weight") {
      return {
        "Squats": "3x10",
        "Bench Press": "3x8",
        "Deadlift": "3x8",
        "Running": "3 miles",
      };
    } else if (userGoal === "Gain muscle") {
      return {
        "Squats": "4x8",
        "Bench Press": "4x8",
        "Deadlift": "4x8",
        "Running": "1 mile",
      };
    } else {
      // Maintain weight
      return {
        "Squats": "3x12",
        "Bench Press": "3x12",
        "Deadlift": "3x12",
        "Running": "2 miles",
      };
    }
  };

  const workoutPlan = getWorkoutPlan();
  const workoutKeys = Object.keys(workoutPlan);
  const selectedWorkout = workoutKeys[selectedDate.getDay() % workoutKeys.length];
  const workoutDetails = workoutPlan[selectedWorkout];

  // Fetch streak from database
  useEffect(() => {
    const fetchStreak = async () => {
      if (!userId) return;
      try {
        const response = await fetch(buildPath(`api/streak?userId=${userId}`));
        const data = await response.json();
        if (response.ok && typeof data.streaks === "number") {
          setStreak(data.streaks);
        }
      } catch (err) {
        console.error("Failed to fetch streak:", err);
      }
    };
    fetchStreak();
  }, [userId]);

  // Update streak in database
  const handleStatusChange = async (value: DayStatus) => {
    const key = formatDate(selectedDate);
    setDayData((prev) => ({ ...prev, [key]: value }));

    if (!userId) return;

    try {
      if (value === "workout") {
        const res = await fetch(buildPath("api/increment-streak"), {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ userId }),
        });
        if (res.ok) setStreak((prev) => prev + 1);
      } else if (value === "missed") {
        const res = await fetch(buildPath("api/reset-streak"), {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ userId }),
        });
        if (res.ok) setStreak(0);
      }
    } catch (err) {
      console.error("Error updating streak:", err);
    }
  };

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

  // more streak, more red
  const getGradient = (streak: number): string => {
    const clamped = Math.max(0, Math.min(streak, 30));
  
    // Phase 1: Blue (0) → Red (15)
    const transitionToRed = Math.min(clamped, 15) / 15;
    const startR = Math.floor(59 + transitionToRed * (255 - 59));   // 59 → 255
    const startG = Math.floor(130 - transitionToRed * 130);         // 130 → 0
    const startB = Math.floor(246 - transitionToRed * 246);         // 246 → 0
  
    const startColor = `rgb(${startR}, ${startG}, ${startB})`;
  
    // Phase 2: White (15) → Red (30)
    const fadeWhiteToRed = clamped > 15 ? (clamped - 15) / 15 : 0;
    const endR = 255;
    const endG = Math.floor(255 - fadeWhiteToRed * 255);            // 255 → 0
    const endB = Math.floor(255 - fadeWhiteToRed * 255);            // 255 → 0
  
    const endColor = `rgb(${endR}, ${endG}, ${endB})`;
  
    return `linear-gradient(to bottom right, ${startColor}, ${endColor})`;
  };
 
    

  return (
    <div
    className="h-screen flex flex-col transition-all duration-500"
    style={{ background: getGradient(streak) }}
    >
  
      <IconUI />
      <div className="flex flex-1 mt-24 px-8">
        <div className="w-1/3 flex justify-center items-start">
          <div className="max-w-[500px] scale-[1.4]">
            <h2 className="text-2xl font-semibold text-[#0f172a] mb-4 ml-2">
              Welcome, {username}
            </h2>
            <Calendar onChange={(value) => setSelectedDate(value as Date)} value={selectedDate} />
          </div>
        </div>

        <div className="w-1/3 flex flex-col items-center justify-start mt-[-60px]">
          <h2 className="text-2xl font-bold text-[#0f172a] mb-6">
            🔥 Streak: {streak} day{streak !== 1 ? "s" : ""}
          </h2>
          <div className="flex flex-col gap-4 mt-25">
            {(["workout", "rest", "missed"] as DayStatus[]).map((status) => (
              <button
                key={status}
                onClick={() => handleStatusChange(status)}
                className={`px-4 py-2 rounded transition duration-300 active:scale-95 ${
                  selectedStatus === status
                    ? "bg-blue-500 text-white"
                    : "bg-gray-200 text-[#0f172a] hover:bg-blue-100"
                }`}
              >
                {status === "workout" && "🏋️ Workout"}
                {status === "rest" && "😌 Rest"}
                {status === "missed" && "❌ Missed"}
              </button>
            ))}
          </div>
        </div>

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
