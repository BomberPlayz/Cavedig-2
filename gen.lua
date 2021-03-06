gen = {}

local placeQueue = {}

local function setTile(c,x,y,t,...)
    if not c[x] then c[x] = {} end
    if not c[x][y] then c[x][y] = {} end
    c[x][y] = {tile={id=t,data={...}}}
end

function curve(q,r,s,minmaxuse,min,max)
  r=r or 1
  local curve={}
  local prevy=s or 0
  for i=1,q do
    curve[i]=love.math.random(prevy-r,prevy+r)
    if(minmaxuse)then curve[i]=math.max(math.min(curve[i],max),min) end
    prevy=curve[i]
  end
  return curve
end

local terrh = 16
local upa = 5

function gen.genChunk(w,x,y)
  local curv = {}
  for i=1,world.chunkSize do
    curv[i]=love.math.noise((i+world.chunkSize*x)/64)*16
  end
  local d = {}
  for i = 1,world.chunkSize do
    d[i] = d[i] or {}



    for j = 1,world.chunkSize do

      local ide = world.chunkSize*y + j > curv[i] and world.chunkSize*y + j < curv[i]+1 and 2 or world.chunkSize*y + j > curv[i]+1 and world.chunkSize*y + j < curv[i]+6 and 3 or world.chunkSize*y + j > curv[i] and 4 or 1
      --upa = ide == 2 and j
      if ide == 2 then
    --  error("ide: "..j)
      upa = j

      end
      if not d[i][j] then
      d[i][j] = {
        tile={
          id=ide,
          data={}
        }
      }
      if love.math.noise((i+world.chunkSize*x)/100,(j+world.chunkSize*y)/32)*32 > 25 and y > 1 then
        d[i][j] = {
          tile={
            id=1,
            data={}
          }
        }
      end
      if love.math.noise((i+world.chunkSize*x)/16,(j+world.chunkSize*y)/80)*32 > 29 and y < 1 then
        d[i][j] = {
          tile={
            id=1,
            data={}
          }
        }
      end
    end
    --  upa = world.chunkSize*y + j > curv[i] and world.chunkSize*y + j < curv[i]+1 and j
    --  d[i][upa] = {tile={id=0}}
    --  error(upa)
    local th = love.math.random(3,6)
    if love.math.random(1,10000) > 9800 and upa and (i > 0 and i < 16) and upa+th+1 < 17 then

      for ii=1,th-1 do
        d[i][upa-ii] = {
          tile={
            id=5,
            data={}
          }
        }
      end
      setTile(d,i,upa-th,6)
      setTile(d,i+1,upa-th,6)
      setTile(d,i-1,upa-th,6)
      setTile(d,i,upa-th-1,6)

    end



    end

    terrh = curv[i]




  end



  return {
    x = x,
    y = y,
    data = d
  }
end
