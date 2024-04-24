player.onChat("buildCastle", function () {
    // Define the coordinates for the castle
    let startX = player.position().getValue(Axis.X)
    let startY = player.position().getValue(Axis.Y)
    let startZ = player.position().getValue(Axis.Z)

    let size = 20
    let height = 6

    let floorBlock = PLANKS_OAK
    let wallsBlock = STONE_BRICKS
    let glassBlock = GLASS_PANE
    let cornerBlock = LOG_SPRUCE
    let lowBlock = BLACKSTONE
    
    // Build walls
    for (let x = startX; x < startX + size; x++)
    {
        for (let z = startZ; z < startZ + size; z++)
        {
            for (let y = startY; y < startY + height; y++)
            {
                if (x == startX || x == startX + size - 1 ||
                    z == startZ || z == startZ + size - 1 )
                {
                    if (y == startY + height - 1)
                    {
                        if ((x + z) % 2 == 0)
                        continue
                    }

                    if (x - startX == 0 && z - startZ == size / 2 && (y - startY) < 2)
                    {
                        if (y - startY != 0)
                            continue
                        blocks.place(OAK_DOOR, world(x, startY, z))
                        continue
                    }

                    if (x - startX == 0 && z - startZ == 0 || 
                        x - startX + 1 == size && z - startZ + 1 == size ||
                        x - startX == 0 && z - startZ + 1 == size ||
                        x - startX + 1 == size && z - startZ == 0)
                    {
                        blocks.place(cornerBlock, world(x, y, z))
                        continue
                    }

                    if ((x - startX + z - startZ) % 5 == 4 && y - startY > 0 && y - startY < height - 2)
                    {
                        blocks.place(glassBlock, world(x, y, z))
                        continue
                    }

                    if (y - startY == 0)
                        blocks.place(lowBlock, world(x, y, z))
                    else
                        blocks.place(wallsBlock, world(x, y, z))
                }
                    
            }
        }
    }

    // Build floor
    for (let x = startX; x < startX + size; x++)
    {
        for (let z = startZ; z < startZ + size; z++)
        {
            let y = startY - 1
            blocks.place(floorBlock, world(x, y, z))
        }
    }
})
