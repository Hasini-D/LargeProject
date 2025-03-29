import { useNavigate } from 'react-router-dom';
import ProfileUI from '../components/ProfileUI'; // Adjust the import path if necessary

function ProfilePage() {
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      // Call the logout API (optional if no server-side action is needed)
      await fetch('/api/logout', { method: 'POST' });

      // Clear the token from local storage
      localStorage.removeItem('token_data');

      // Redirect to the login page
      navigate('/login');
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  return (
    <div>
      <ProfileUI />
      <button onClick={handleLogout} style={{ marginTop: '20px' }}>
        Logout
      </button>
    </div>
  );
}

export default ProfilePage;