import { useNavigate } from "react-router-dom";
function IconUI() {
  const navigate = useNavigate();
  return (
    <header className="w-full bg-white shadow-md px-6 py-4 sticky top-0 z-50">
      <div className="flex items-center justify-between">
        <h1 className="text-5xl font-bold text-[#0f172a]">Fit Journey</h1>
        {/* Icons */}
        <div className="flex items-center space-x-6">
          {/* Home Button */}
          <button
            onClick={() => navigate("/dashboard")}
            className="text-[#0f172a] hover:text-[#2563eb] transition"
          >
            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" strokeWidth="1.5"
              stroke="currentColor" className="w-8 h-8">
              <path strokeLinecap="round" strokeLinejoin="round"
                d="M2.25 12L11.204 3.045a1.125 1.125 0 0 1 1.591 0L21.75 12M4.5 9.75v10.125A1.125 1.125 0 0 0 5.625 21h3.375v-4.875A1.125 1.125 0 0 1 10.125 15h2.25a1.125 1.125 0 0 1 1.125 1.125V21h3.375a1.125 1.125 0 0 0 1.125-1.125V9.75" />
            </svg>
          </button>
          {/* Calendar Button */}
          <button
            onClick={() => navigate("/calendar")}
            className="text-[#0f172a] hover:text-[#2563eb] transition"
          >
            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" strokeWidth="1.5"
              stroke="currentColor" className="w-8 h-8">
              <path strokeLinecap="round" strokeLinejoin="round"
                d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5
                a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25
                0 0 1 21 7.5v11.25a2.25 2.25 0 0 1-2.25
                2.25H5.25A2.25 2.25 0 0 1 3 18.75z" />
            </svg>
          </button>
          {/* Diet Button */}
          <button
            onClick={() => navigate("/diet")}
            className="text-[#0f172a] hover:text-[#2563eb] transition"
          >
            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 50 50" className="w-8 h-8">
              <g>
                <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                  d="M40.15 28.26c-7.05 7.05-19.72 10.58-25.36 4.94
                    -5.64-5.64-2.1-18.31 4.94-25.36 7.05-7.05 14.94-5.8 20.58-0.16
                    5.64 5.64 6.89 13.53-0.16 20.58Z" strokeWidth="3" />
                <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round"
                  d="M12.86 30.25l-3.02 4.23c-.36.5-1.09.55-1.64.28
                    -.48-.24-1.02-.37-1.59-.37-1.99 0-3.61 1.62-3.61 3.61
                    0 1.62 1.06 2.98 2.53 3.44.49.15.89.55 1.04 1.04.36 1.2 1.73 2.26
                    3.35 2.26 1.99 0 3.61-1.62 3.61-3.61 0-.57-.13-1.11-.37-1.59
                    -.27-.55-.22-1.28.28-1.64l4.23-3.03" strokeWidth="3" />
              </g>
            </svg>
          </button>
          {/* Friends Button */}
          <button
            onClick={() => navigate("/friends")}
            className="text-[#0f172a] hover:text-[#2563eb] transition"
          >
            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" strokeWidth="1.5"
              stroke="currentColor" className="w-8 h-8">
              <path strokeLinecap="round" strokeLinejoin="round"
                d="M18 18.72a9.094 9.094 0 0 0 3.741-.479
                  3 3 0 0 0-4.682-2.72m.94 3.198v.031c0 .225-.012.447-.037.666
                  A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584
                  A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197
                  m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058
                  2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477
                  m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0
                  3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0
                  2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0
                  2.25 2.25 0 0 1 4.5 0Z" />
            </svg>
          </button>
          {/* Profile Button */}
          <button
            onClick={() => navigate("/profile")}
            className="text-[#0f172a] hover:text-[#2563eb] transition"
          >
            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
              viewBox="0 0 24 24" strokeWidth="1.5"
              stroke="currentColor" className="w-8 h-8">
              <path strokeLinecap="round" strokeLinejoin="round"
                d="M15.75 6a3.75 3.75 0 1 1-7.5 0
                  3.75 3.75 0 0 1 7.5 0ZM4.501 20.118
                  a7.5 7.5 0 0 1 14.998 0
                  A17.933 17.933 0 0 1 12 21.75
                  c-2.676 0-5.216-.584-7.499-1.632Z" />
            </svg>
          </button>
        </div>
      </div>
    </header>
  );
}
export default IconUI;
