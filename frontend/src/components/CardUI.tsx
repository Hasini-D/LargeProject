import { useState } from 'react';
import { buildPath } from './Path';

const app_name = 'fitjourneyhome.com';

function CardUI() {
    //var bp = require('./Path.js'); //Added build path
    let _ud: any = localStorage.getItem('user_data');
    let ud = JSON.parse(_ud);
    let userId: string = ud?.id || '';

    const [message, setMessage] = useState('');
    const [searchResults, setResults] = useState('');
    const [cardList, setCardList] = useState('');
    const [search, setSearchValue] = useState('');
    const [card, setCardNameValue] = useState('');

    function handleSearchTextChange(e: any): void {
        setSearchValue(e.target.value);
    }

    function handleCardTextChange(e: any): void {
        setCardNameValue(e.target.value);
    }

    async function addCard(e: any): Promise<void> {
        e.preventDefault();
        let obj = { userId: userId, card: card };
        let js = JSON.stringify(obj);

        try {
            // New code for fetch
            const response = await fetch(buildPath('api/addcard'), {
                method: 'POST',
                body: js, // Ensure `js` is properly stringified
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new TypeError("Received non-JSON response");
            }

            let res = await response.json();
            if (res.error.length > 0) {
                setMessage("API Error: " + res.error);
            } else {
                setMessage('Card has been added');
            }
        } catch (error: any) {
            setMessage(error.toString());
        }
    };

    async function searchCard(e: any): Promise<void> {
        e.preventDefault();
        let obj = { userId: userId, search: search };
        let js = JSON.stringify(obj);

        try {
            //New code for fetch
            const response = await fetch(buildPath('api/searchcards'), {
                method: 'POST',
                body: js, // Ensure `js` is properly stringified
                headers: {
                    'Content-Type': 'application/json',
                },
            });
            

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new TypeError("Received non-JSON response");
            }

            let res = await response.json();
            let resultText = res.results.join(', ');

            setResults('Card(s) retrieved:');
            setCardList(resultText);
        } catch (error: any) {
            alert(error.toString());
            setResults(error.toString());
        }
    };

    return (
        <div id="cardUIDiv">
            <br />
            Search:
            <input type="text" id="searchText" placeholder="Card To Search For" value={search} onChange={handleSearchTextChange} />
            <button type="button" id="searchCardButton" className="buttons" onClick={searchCard}> Search Card </button><br />
            <span id="cardSearchResult">{searchResults}</span>
            <p id="cardList">{cardList}</p><br /><br />

            Add:
            <input type="text" id="cardText" placeholder="Card To Add" value={card} onChange={handleCardTextChange} />
            <button type="button" id="addCardButton" className="buttons" onClick={addCard}> Add Card </button><br />
            <span id="cardAddResult">{message}</span>
        </div>
    );
}

export default CardUI;