const { ref, onBeforeUnmount } = Vue

let currentBooth = null;
let currentLink = null;

const dj = {
    setup () {
        return {
          text: ref(''),
          volume: ref(0),
        }
    },
    methods: {
        LinkUpdate: function(event) { 
            currentLink = event;
        },
        PlaySong: function() { 
            $.post('https://devyn-dj/Play', JSON.stringify({booth: currentBooth, song: currentLink}));
        },
        ResumeSong: function() { 
            $.post('https://devyn-dj/Resume', JSON.stringify({booth: currentBooth }));
        },
        PauseSong: function() { 
            $.post('https://devyn-dj/Pause', JSON.stringify({booth: currentBooth }));
        },
        VolumeAdjust: function(event) { 
            $.post('https://devyn-dj/Volume', JSON.stringify({booth: currentBooth, volume: event }));
        },
    }
}

const app = Vue.createApp(dj);
app.use(Quasar);
app.mount(".dj-container");

$(document).ready(function () {
    window.addEventListener("message", function (event) {
        switch (event.data.action) {
        case "open":
            openMenu(event.data);
            break;
        case "track":
            displayTrack(event.data)
            break;
        case "booth":
            setBooth(event.data)
            break;
      }
    });
});

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        closeMenu()
    } 
};
  
function closeMenu() {
    $(".dj-container").fadeOut(150);
    currentBooth = null;
    $.post('https://devyn-dj/Close');
}

function openMenu(data) {
    currentBooth = data.booth
    $(".dj-container").fadeIn(150);
}

function displayTrack(data) {

}

function setBooth(data) {
    currentBooth = data.booth;
}
