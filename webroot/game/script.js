const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

function resizeCanvas() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
}
resizeCanvas();
window.addEventListener('resize', () => {
  resizeCanvas();
  updateBackgroundImage();
});

function getWidth() {
  return canvas.width;
}
function getHeight() {
  return canvas.height;
}

const planeImg = new Image();
planeImg.src = 'meowverse.png';

const bgPortrait = new Image();
bgPortrait.src = 'image.png';
bgPortrait.onerror = () => console.error('Failed to load image.png');

const bgLandscape = new Image();
bgLandscape.src = 'image2.png';
bgLandscape.onerror = () => console.error('Failed to load image2.png');

let bgImg = new Image();
function updateBackgroundImage() {
  const isPortrait = window.innerHeight > window.innerWidth;
  bgImg = isPortrait ? bgPortrait : bgLandscape;
}
updateBackgroundImage();

let plane = {
  x: 150,
  y: getHeight() / 2,
  width: 150,
  height: 113,
  velocityY: 0,
  gravity: 0.3,
  jumpForce: -6,
  maxVelocityY: 10,
  rotation: 0,
  speed: 16
};

let buildings = [];
let clouds = [];
let boosts = [];
let frame = 0;
let score = 0;
let highScore = localStorage.getItem('highScore') || 0;
let gameOver = false;
let skyColor = randomSkyColor();
let transitionProgress = 0;

const buildingWidth = 120;
const gapHeight = 350;

function randomSkyColor() {
  const skies = ['#87CEEB', '#FFA07A', '#191970'];
  return skies[Math.floor(Math.random() * skies.length)];
}

function transitionSkyColor() {
  const targetSkyColor = randomSkyColor();
  if (transitionProgress < 1) {
    transitionProgress += 0.005;
  } else {
    skyColor = targetSkyColor;
    transitionProgress = 0;
  }
  return skyColor;
}

function spawnBuilding() {
  let topHeight = Math.random() * (getHeight() - gapHeight - 150) + 80;
  buildings.push({ x: getWidth(), top: topHeight });
}

function drawBuildings() {
  ctx.fillStyle = 'rgba(169, 169, 169, 1)';
  for (let b of buildings) {
    ctx.fillRect(b.x, 0, buildingWidth, b.top);
    ctx.fillRect(b.x, b.top + gapHeight, buildingWidth, getHeight() - b.top - gapHeight);
    ctx.fillStyle = 'rgba(105, 105, 105, 1)';
    ctx.fillRect(b.x + 10, b.top + gapHeight, buildingWidth - 20, 20);
    ctx.fillStyle = 'rgba(169, 169, 169, 1)';
  }
}

function spawnCloud() {
  clouds.push({ x: getWidth(), y: Math.random() * getHeight() / 2 });
}

function drawClouds() {
  ctx.fillStyle = 'rgba(255, 255, 255, 0.6)';
  for (let c of clouds) {
    ctx.beginPath();
    ctx.arc(c.x, c.y, 30, 0, Math.PI * 2);
    ctx.fill();
  }
}

function spawnBoost() {
  boosts.push({ x: getWidth(), y: Math.random() * getHeight() / 2 });
}

function drawBoosts() {
  ctx.fillStyle = 'rgba(255, 215, 0, 0.8)';
  for (let b of boosts) {
    ctx.beginPath();
    ctx.arc(b.x, b.y, 20, 0, Math.PI * 2);
    ctx.fill();
  }
}

function drawPlane() {
  ctx.save();
  ctx.translate(plane.x, plane.y);
  ctx.rotate(plane.rotation);
  ctx.drawImage(planeImg, -plane.width / 2, -plane.height / 2, plane.width, plane.height);
  ctx.restore();
}

function drawScore() {
  ctx.fillStyle = '#FFF';
  ctx.font = '15px Mona, Arial';
  ctx.fillText('Score: ' + score, 20, 50);
  ctx.fillText('High Score: ' + highScore, 20, 80);
}

function drawGameOver() {
  ctx.fillStyle = '#FFF';
  ctx.font = '20px Mona, Arial';
  ctx.fillText('Game Over', getWidth() / 2 - 100, getHeight() / 2);
  ctx.fillText('Click to Restart', getWidth() / 2 - 130, getHeight() / 2 + 50);
}

function checkCollision() {
  for (let b of buildings) {
    if (
      plane.x + plane.width / 2 > b.x &&
      plane.x - plane.width / 2 < b.x + buildingWidth &&
      (plane.y - plane.height / 2 < b.top || plane.y + plane.height / 2 > b.top + gapHeight)
    ) {
      gameOver = true;
      if (score > highScore) {
        highScore = score;
        localStorage.setItem('highScore', highScore);
      }
    }
  }

  for (let b of boosts) {
    if (
      plane.x + plane.width / 2 > b.x &&
      plane.x - plane.width / 2 < b.x + 40 &&
      plane.y + plane.height / 2 > b.y - 20 &&
      plane.y - plane.height / 2 < b.y + 20
    ) {
      boosts = boosts.filter((boost) => boost !== b);
      score += 10;
    }
  }
}

function updateClouds() {
  for (let c of clouds) {
    c.x -= plane.speed / 2;
  }
  clouds = clouds.filter((cloud) => cloud.x > -30);
}

function updateBuildings() {
  for (let b of buildings) {
    b.x -= plane.speed;
  }

  if (buildings.length > 0 && buildings[0].x < -buildingWidth) {
    buildings.shift();
  }

  if (frame % 100 === 0) {
    spawnBuilding();
  }
}

function updateBoosts() {
  for (let b of boosts) {
    b.x -= plane.speed;
  }
  boosts = boosts.filter((boost) => boost.x > -40);
  if (frame % 300 === 0) {
    spawnBoost();
  }
}

function flap() {
  if (!document.fullscreenElement) {
    canvas.requestFullscreen().catch(err => {
      console.warn(`Fullscreen error: ${err.message}`);
    });
  }

  if (gameOver) {
    resetGame();
  } else {
    plane.velocityY = plane.jumpForce;
  }
}

function resetGame() {
  plane.y = getHeight() / 2;
  plane.velocityY = 0;
  buildings = [];
  clouds = [];
  boosts = [];
  score = 0;
  gameOver = false;
  spawnBuilding();
}

function gameLoop() {
  ctx.fillStyle = transitionSkyColor();
  ctx.fillRect(0, 0, getWidth(), getHeight());

  if (bgImg.complete && bgImg.naturalWidth !== 0) {
    ctx.drawImage(bgImg, 0, 0, getWidth(), getHeight());
  }

  if (planeImg.complete) {
    if (!gameOver) {
      plane.velocityY += plane.gravity;
      plane.y += plane.velocityY;
      if (plane.velocityY > plane.maxVelocityY) {
        plane.velocityY = plane.maxVelocityY;
      }

      updateClouds();
      updateBuildings();
      updateBoosts();
      checkCollision();
      score++;
    }

    drawClouds();
    drawBoosts();
    drawBuildings();
    drawPlane();
    drawScore();

    if (gameOver) {
      drawGameOver();
    }
  } else {
    ctx.fillStyle = 'black';
    ctx.font = '20px Arial';
    ctx.fillText('Loading...', getWidth() / 2 - 80, getHeight() / 2);
  }

  frame++;
  requestAnimationFrame(gameLoop);
}

canvas.addEventListener('click', flap);
spawnBuilding();
gameLoop();
