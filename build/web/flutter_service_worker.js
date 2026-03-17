'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "886d17f9b85ed094675b3efdffc8905f",
"assets/AssetManifest.bin.json": "9a7f482c09b02968b19ab39dacd5c1cc",
"assets/AssetManifest.json": "d8f1406ab2a8992281892c4ef77644fc",
"assets/assets/data/recipes.json": "31b5d753eaf466ab3158441f732aff3e",
"assets/assets/images/bolognaise.jpg": "85af65ca3271bef15d83c25632b0bb82",
"assets/assets/images/burger.jpg": "e67bae9c830a6c321e00ccae75a73d00",
"assets/assets/images/carbonara.jpg": "295fc001ef6bfe3fdb667431cdfbc636",
"assets/assets/images/chili.jpg": "7fecebb96338eadbd9f1a113a69f99bb",
"assets/assets/images/classiques.jpg": "1faab505593da4b00f564e09ac7408d5",
"assets/assets/images/curry.jpg": "91db8775ccb45d25bcf53b86bfbe0465",
"assets/assets/images/etudiant.jpg": "5f65cf3e1e6046cedf1fee528a785603",
"assets/assets/images/gratin.jpg": "02104c4e31fe9338f4f2e921d4df88a2",
"assets/assets/images/hiver.jpg": "ecb2b3978f71fd39ee7c633f1bd02303",
"assets/assets/images/nouilles.jpg": "f1687a4bcf42ab7bccc22b74470384e5",
"assets/assets/images/omelette.jpg": "4953f23f587042f7d7a1bb37cfac5fb2",
"assets/assets/images/omelette_fromage.jpg": "a19da0ae24c527e0885ce49d17ac72ec",
"assets/assets/images/pancakes.jpg": "25830a81a029e757b1946c72363747fe",
"assets/assets/images/pates_thon.jpg": "75575e25d2c9688dd41c1856d7db8711",
"assets/assets/images/pdt_four.jpg": "46f526e20d36985af82e9e647bb51bda",
"assets/assets/images/pizza.jpg": "f7e0d75c4843d934a5d8606d649ef9b1",
"assets/assets/images/poulet_riz.jpg": "77753606efdade85598a1c6153af921d",
"assets/assets/images/printemps.jpg": "225745e15c5400f3c0c7388d6252fa23",
"assets/assets/images/riz_oeuf.jpg": "f7ecb15ca454a430fcd49f5b2a1b592b",
"assets/assets/images/salade.jpg": "79ebb64b5524c400a2481782e8cc75ce",
"assets/assets/images/salade_quinoa.jpg": "6cae1a482911a419927e6e06ced36879",
"assets/assets/images/salade_thon.jpg": "5e44b0042ad41826a45e48dc4b2fdc18",
"assets/assets/images/sans_gluten.webp": "39fffd4f804ed839fbf4c0c42d13545f",
"assets/assets/images/saumon.jpg": "22a8672906092bf556fa3b6a6d8299ac",
"assets/assets/images/smoothie.jpg": "f6612e61f1713372f371acb82e2f8ba2",
"assets/assets/images/soupe_legumes.jpg": "e1f63d29a2645186922dc0d19f2f6230",
"assets/assets/images/tartines_avocat.jpg": "2aae0067908efd63ded255ce9cd1dc78",
"assets/assets/images/vegetarien.jpg": "84894c328614c15d45da18a53268ee3d",
"assets/assets/images/WhatsApp%2520Image%25202026-03-10%2520at%252014.13.32.jpeg": "7df0aea6028420b85d82a19543ad1e83",
"assets/assets/images/wrap.jpg": "5e2ee00e8895eadb97b3965da0653a33",
"assets/assets/images/wrap_poulet.jpg": "0a8ca1ec50eeaeee625af89f7e1d8697",
"assets/assets/logo/ma_recette_logo.png": "817b310f20a13796a6a8c9b483b5cbc3",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "ad227f8f3f09a547fb51a648bb76fb94",
"assets/NOTICES": "d876173f009371fec2b5db53b6eb6ca2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "1087bac0f64da692714bc0f5c1173170",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "03404f2a82c58ad49b00be41150cd273",
"/": "03404f2a82c58ad49b00be41150cd273",
"main.dart.js": "7d1c0dee5b5717ae80a67b39ba27ae8d",
"manifest.json": "4f1cbcb5dc24ea624e67853f63e6bdd8",
"version.json": "cb0b63769887f891d0c2c98c12d4f98e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
