class SearchEngineModel {
  String? name;
  String? imageAddress;
  String? searchUrl;

  SearchEngineModel(
      { this.name,
       this.imageAddress,
       this.searchUrl});
}

List<SearchEngineModel> searchEngines = [
  SearchEngineModel(
      name: 'Google',
      imageAddress: 'image address of google image',
      searchUrl: "https://www.google.com/search?q="),
  SearchEngineModel(
      name: 'Yahoo',
      imageAddress: 'image address of yahoo image',
      searchUrl: "https://www.yahoo.com/search?q="),
  SearchEngineModel(
      name: 'Youtube',
      imageAddress: 'image address of youtube image',
      searchUrl: "https://www.youtube.com/search?q="),
];
