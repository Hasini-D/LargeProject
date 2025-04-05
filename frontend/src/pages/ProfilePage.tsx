import { useNavigate } from 'react-router-dom';
import ProfileUI from '../components/ProfileUI'; // Adjust the import path if necessary
import { buildPath } from '../components/Path';

function ProfilePage() {
  const navigate = useNavigate();

  const handleLogout = async () => {
    try {
      // Call the logout API
      await fetch(buildPath('api/logout'), { method: 'POST' });

      // Clear the token from local storage
      localStorage.removeItem('token_data');
      localStorage.removeItem('user_data');

      // Redirect to the login page
      navigate('/login');
    } catch (error) {
      console.error('Logout failed:', error);
    }
  };

  const handleDeleteAccount = async () => {
    // Retrieve the user's login from localStorage
    const userData = JSON.parse(localStorage.getItem('user_data') || '{}');
    const userLogin = userData?.login;

    if (!userLogin) {
      alert('No user is logged in.');
      return;
    }

    // Show confirmation dialog
    const confirmDelete = window.confirm(
      `Are you sure you want to delete the account for "${userLogin}"? This action cannot be undone.`
    );

    if (confirmDelete) {
      try {
        const token = localStorage.getItem('token_data');

        if (!token) {
          alert('You are not logged in.');
          return;
        }

        // Make the DELETE request to the backend
        const response = await fetch(buildPath('api/delete'), {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${token}`,
          },
        });

        if (response.ok) {
          alert('Account deleted successfully.');
          localStorage.removeItem('token_data');
          localStorage.removeItem('user_data');
          navigate('/register'); // Redirect to the registration page
        } else {
          const errorData = await response.json().catch(() => null); // Handle empty response
          const errorMessage = errorData?.error || 'An unexpected error occurred.';
          alert(`Failed to delete account: ${errorMessage}`);
        }
      } catch (error) {
        console.error('Error deleting account:', error);
        alert('An error occurred while deleting your account. Please try again later.');
      }
    }
  };

  return (
    <div>
      <ProfileUI />
      <button onClick={handleLogout} style={{ marginTop: '20px' }}>
        Logout
      </button>
      <button
        onClick={handleDeleteAccount}
        style={{
          marginTop: '20px',
          marginLeft: '10px',
          backgroundColor: 'red',
          color: 'white',
          padding: '10px',
          borderRadius: '5px',
        }}
      >
        Delete Account
      </button>
    </div>
  );
}

export default ProfilePage;