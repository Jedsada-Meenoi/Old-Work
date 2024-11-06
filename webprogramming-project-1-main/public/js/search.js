// public/js/search.js

const searchForm = document.getElementById('search-form');
const searchResults = document.getElementById('search-results');

searchForm.addEventListener('submit', (event) => {
  event.preventDefault();

  const name = document.getElementById('name').value;
  const country = document.getElementById('country').value;
  const price = document.getElementById('price').value;

  fetch(`/search?name=${name}&country=${country}&price=${price}`)
    .then(response => response.json())
    .then(data => displayResults(data))
    .catch(error => console.error(error));
});

function displayResults(results) {
  let html = '<table>';

  // create table header
  html += '<tr><th>Name</th><th>Country</th><th>Price</th></tr>';

  // create table rows
  results.forEach(result => {
    html += `<tr><td>${result.name}</td><td>${result.country}</td><td>${result.price}</td></tr>`;
  });

  html += '</table>';

  searchResults.innerHTML = html;
}
