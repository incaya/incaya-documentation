"use strict";
window.SearchApp = {
  searchField: document.getElementById("searchField"),
  searchButton: document.getElementById("searchButton"),
  output: document.getElementById("output"),
  display: document.getElementById("searchResult"),
  searchData: {},
  searchIndex: {},
};

axios.get("/search.json").then((response) => {
  SearchApp.searchData = response.data;
  SearchApp.searchIndex = lunr(function () {
    this.ref("uri");
    this.field("title");
    this.field("content");
    this.k1(1.3);
    this.b(0);
    response.data.forEach((e) => {
      this.add({
        "uri": e.uri,
        "title": e.title,
        "content": e.content,
      });
    });
  });
});

SearchApp.searchButton.addEventListener("click", search);
document.getElementById('searchField').onkeydown = function(e){
  if(e.key === 'Enter' && !!e.target.value){
    search();
  }
};

function search() {
  let searchText = SearchApp.searchField.value;
  let resultList = SearchApp.searchIndex.search(searchText);
  let results = resultList.map((entry) => {
    let data = SearchApp.searchData.find(data => data.uri === entry.ref);
    return data;
  });
  if (results.length) {
    SearchApp.display.innerText = results.length > 1 ? `${results.length} résultats pour votre recherche.` : "1 résultat pour votre recherche.";
  } else {
    SearchApp.display.innerText = `Aucun résltat pour la recherche "${searchText}".`
  }
  display(results);
}

function display(list) {
  SearchApp.output.innerHTML = "";
  if (list.length > 0) {
    list.forEach((el) => {
        const div = document.createElement("div");
        div.class = "summary mb-2";
        const h2 = document.createElement("h2");
        h2.class = "title-summary";
        const a = document.createElement("a");
        a.href = el.uri;
        a.text = el.title;
        h2.appendChild(a);
        div.appendChild(h2);
        const pMeta = document.createElement("p");
        pMeta.class = "adr-meta";
        pMeta.innerHTML = `Type : ${el.categories[0]}`;
        const p = document.createElement("p");
        p.innerHTML = el.description;
        div.appendChild(pMeta);
        div.appendChild(p);
        SearchApp.output.appendChild(div);
    });
    SearchApp.searchField.value = "";
  }
}

