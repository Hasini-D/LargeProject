import React, { useState } from 'react';
import { buildPath } from './Path';
import { storeToken, retrieveToken } from '../tokenStorage';

function CardUI() {
  // Retrieve user data from localStorage.
  const _ud: string | null = localStorage.getItem('user_data');
  if (!_ud) {
    throw new Error("User data not found in localStorage");
  }
  const ud = JSON.parse(_ud);
  const userId: string = ud.id || '';

  const [message, setMessage] = useState<string>('');
  const [searchResults, setResults] = useState<string>('');
  const [cardList, setCardList] = useState<string>('');
  const [search, setSearchValue] = useState<string>('');
  const [card, setCardNameValue] = useState<string>('');

  function handleSearchTextChange(e: React.ChangeEvent<HTMLInputElement>): void {
    setSearchValue(e.target.value);
  }

  function handleCardTextChange(e: React.ChangeEvent<HTMLInputElement>): void {
    setCardNameValue(e.target.value);
  }

  async function addCard(e: React.MouseEvent<HTMLButtonElement>): Promise<void> {
    e.preventDefault();
    // Retrieve the JWT token from storage
    let jwtToken = retrieveToken();
    console.log("Using token for addCard:", jwtToken);

    if (!jwtToken) {
      setMessage("JWT Token is missing. Please log in again.");
      return;
    }

    const obj = { userId: userId, card: card, jwtToken: jwtToken };
    const js = JSON.stringify(obj);

    try {
      const response = await fetch(buildPath('api/addcard'), {
        method: 'POST',
        body: js,
        headers: {
          'Content-Type': 'application/json',
        },
      });

      const res = await response.json();

      if (res.error && res.error.length > 0) {
        setMessage("API Error: " + res.error);
      } else {
        setMessage('Card has been added');
        if (res.jwtToken) {
          // Store the refreshed token if it was returned
          storeToken(res.jwtToken);
        }
      }
    } catch (error: any) {
      setMessage(error.toString());
    }
  }

  async function searchCard(e: React.MouseEvent<HTMLButtonElement>): Promise<void> {
    e.preventDefault();
    let jwtToken = retrieveToken();
    console.log("Using token for searchCard:", jwtToken);

    if (!jwtToken) {
      setMessage("JWT Token is missing. Please log in again.");
      return;
    }

    const obj = { userId: userId, search: search, jwtToken: jwtToken };
    const js = JSON.stringify(obj);

    try {
      const response = await fetch(buildPath('api/searchcards'), {
        method: 'POST',
        body: js,
        headers: {
          'Content-Type': 'application/json',
        },
      });

      const res = await response.json();

      if (res.error && res.error.length > 0) {
        setMessage("API Error: " + res.error);
      } else {
        const resultText: string = Array.isArray(res.results)
          ? res.results.join(', ')
          : '';

        setResults('Card(s) have been retrieved');
        setCardList(resultText);

        if (res.jwtToken) {
          // Store the refreshed token if it was returned
          storeToken(res.jwtToken);
        }
      }
    } catch (error: any) {
      console.error(error.toString());
      setResults(error.toString());
    }
  }

  return (
    <div id="cardUIDiv">
      <br />
      <label htmlFor="searchText">Search:</label>
      <input
        type="text"
        id="searchText"
        placeholder="Card To Search For"
        value={search}
        onChange={handleSearchTextChange}
      />
      <button type="button" id="searchCardButton" className="buttons" onClick={searchCard}>
        Search Card
      </button>
      <br />
      <span id="cardSearchResult">{searchResults}</span>
      <p id="cardList">{cardList}</p>
      <br />
      <br />
      <label htmlFor="cardText">Add:</label>
      <input
        type="text"
        id="cardText"
        placeholder="Card To Add"
        value={card}
        onChange={handleCardTextChange}
      />
      <button type="button" id="addCardButton" className="buttons" onClick={addCard}>
        Add Card
      </button>
      <br />
      <span id="cardAddResult">{message}</span>
    </div>
  );
}

export default CardUI;
