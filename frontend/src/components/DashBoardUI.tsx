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

  const formatDate = (date: Date) => date.toDateString();
  const selectedStatus = dayData[formatDate(selectedDate)] || "none";

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

  return (
    <div className="h-screen bg-gradient-to-br from-[#e0f7f4] via-[#f2fdfc] to-[#ffffff] flex flex-col">
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
      </div>
    </div>
  );
}

export default CalendarUI;
