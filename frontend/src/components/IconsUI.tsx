import { useNavigate } from "react-router-dom";

function IconUI() {
  
    const navigate = useNavigate();

    return (

    <div className="h-screen bg-white flex flex-col">
            {/* Top Bar */}
            <div className="w-full flex items-center justify-between bg-white shadow-md px-6 py-4 fixed top-0 left-0 z-50">
                <h1 className="text-5xl font-bold text-[#0f172a]">
                    Fit Journey
                </h1>

                {/* Icons */}
                <div className="flex items-center space-x-6">
                    {/* Home Button */}
                    <button onClick={() => navigate('/dashboard')} className="text-[#0f172a] hover:text-[#2563eb] transition">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" className="w-8 h-8">
                            <path strokeLinecap="round" strokeLinejoin="round" d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                        </svg>
                    </button>

                    {/* Calendar Button */}
                    <button onClick={() => navigate('/calendar')} className="text-[#0f172a] hover:text-[#2563eb] transition >">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" className="w-8 h-8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
                    </svg>
                    </button>

                    {/* Diet Button */}
                    <button onClick={() => navigate('/diet')} className="text-[#0f172a] hover:text-[#2563eb] transition">
                        <svg 
                            xmlns="http://www.w3.org/2000/svg" 
                            fill="none" 
                            viewBox="0 0 50 50" 
                            className="w-8 h-8"
                        >
                            <desc>Drum Stick Streamline Icon</desc>
                            <g>
                                <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" d="M40.1544 28.2629c-7.0476 7.0476 -19.724 10.5828 -25.3621 4.9448 -5.63805 -5.6381 -2.1028 -18.3145 4.9448 -25.36208 7.0476 -7.047581 14.9387 -5.79757 20.5768 -0.1595 5.6381 5.63808 6.8881 13.52918 -0.1595 20.57678Z" strokeWidth="3"></path>
                                <path stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" d="m12.8596 30.249 -3.0235 4.2292c-0.35894 0.502 -1.08548 0.5485 -1.63902 0.2756 -0.48052 -0.237 -1.02141 -0.3701 -1.5934 -0.3701 -1.99242 0 -3.60759 1.6152 -3.60759 3.6076 0 1.6158 1.06224 2.9835 2.52647 3.4428 0.48644 0.1526 0.88572 0.552 1.03818 1.0385C7.0198 43.9373 8.38771 45 10.0038 45c1.9924 0 3.6076 -1.6152 3.6076 -3.6076 0 -0.5702 -0.1323 -1.1096 -0.3679 -1.589 -0.2717 -0.553 -0.2247 -1.2778 0.2764 -1.6363l4.2303 -3.0268" strokeWidth="3"></path>
                            </g>
                        </svg>
                    </button>


                    {/* Friends Button */}
                    <button onClick={() => navigate('/friends')} className="text-[#0f172a] hover:text-[#2563eb] transition">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" className="w-8 h-8">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M18 18.72a9.094 9.094 0 0 0 3.741-.479 3 3 0 0 0-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0 1 12 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 0 1 6 18.719m12 0a5.971 5.971 0 0 0-.941-3.197m0 0A5.995 5.995 0 0 0 12 12.75a5.995 5.995 0 0 0-5.058 2.772m0 0a3 3 0 0 0-4.681 2.72 8.986 8.986 0 0 0 3.74.477m.94-3.197a5.971 5.971 0 0 0-.94 3.197M15 6.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm6 3a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Zm-13.5 0a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0Z" />
                        </svg>
                    </button>

                    {/* Profile Button */}
                    <button onClick={() => navigate('/profile')} className="text-[#0f172a] hover:text-[#2563eb] transition">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" className="w-8 h-8">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>


  );
}

export default IconUI;