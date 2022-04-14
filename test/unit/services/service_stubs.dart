abstract class ServiceStubs {
  static const atristsTop = {
    "artists": [
      {
        "id": "art.44",
        "href": "https://api.napster.com/v2.2/artists/art.44",
        "name": "Eminem",
        "bios": [
          {"bio": "Eminem crashed the mainstream in the late '90s."}
        ],
        "links": {
          "images": {"href": "https://api.napster.com/v2.2/artists/art.44/images"},
        },
      },
    ],
  };

  static const tracksTop = {
    "tracks": [
      {
        "id": "tra.609493773",
        "href": "https://api.napster.com/v2.2/tracks/tra.609493773",
        "name": "Knife Talk",
        "artistName": "Drake",
        "albumName": "Certified Lover Boy",
        "links": {
          "albums": {"href": "https://api.napster.com/v2.2/albums/alb.609492932"},
        },
        "previewURL": "https://listen.hs.llnwd.net/g3/prvw/8/7/4/0/2/2455120478.mp3"
      }
    ],
  };

  static const searchArtists = {
    "search": {
      "data": {
        "artists": [
          {
            "id": "art.954",
            "name": "Weezer",
            "bios": [
              {
                "bio":
                    "When they first appeared on the commercial pop landscape back in 1994, it wasn't without a fair amount of derision from the indie rock cognoscenti."
              }
            ],
            "links": {
              "images": {"href": "https://api.napster.com/v2.2/artists/art.954/images"}
            }
          }
        ],
      },
    }
  };

  static const artistPathPhotos = {
    "images": [
      {
        "url": "http://static.rhap.com/img/356x237/8/2/9/2/10182928_356x237.jpg",
        "width": 356,
      },
    ],
  };
}
