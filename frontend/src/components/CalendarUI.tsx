// import React, { useState } from "react";
// import Calendar from "react-calendar";
import "react-calendar/dist/Calendar.css"; 
import IconUI from "./IconsUI";

function CalendarUI() {

    //   const [date, setDate] = useState(new Date());

    return (
        <div className="h-screen bg-white flex flex-col">
            {/* Top Bar */}
            <IconUI/>

            <h2 className="text-3xl font-bold text-center text-#0f172a mb-6">Calendar</h2>
            {/* {<Calendar onChange={setDate} value={date} /> } */}
        </div>
    );
}

export default CalendarUI;