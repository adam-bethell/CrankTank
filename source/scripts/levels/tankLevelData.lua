TankLevelData = {
    {
        {
            name = "Get Moving",
            startX = 228,
            startY = 210,
            goalX = 228,
            goalY = 100,
            enemiesClass = {},
            enemiesArgs = {}
        },
        {
            name = "Learn to Turn",
            startX = 228,
            startY = 210,
            goalX = 328,
            goalY = 100,
            enemiesClass = {},
            enemiesArgs = {}
        },
        {
            name = "Point and Shoot",
            startX = 228,
            startY = 120,
            goalX = 228,
            goalY = 32,
            enemiesClass = {
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy
            },
            enemiesArgs = {
                {50, 140},
                {350, 150},
                {240, 200},
                {100, 180}
            }
        }
    },
    {
        {
            name = "A Real Threat",
            startX = 328,
            startY = 210,
            goalX = 100,
            goalY = 70,
            enemiesClass = {
                AITankEasy
            },
            enemiesArgs = {
                {130, 100}
            }
        },
        {
            name = "Outnumbered",
            startX = 228,
            startY = 210,
            goalX = 228,
            goalY = 32,
            enemiesClass = {
                AITankEasy,
                AITankEasy
            },
            enemiesArgs = {
                {128, 100},
                {328, 100}
            }
        },
        {
            name = "Equally Matched",
            startX = 50,
            startY = 210,
            goalX = 350,
            goalY = 50,
            enemiesClass = {
                AITankMedium
            },
            enemiesArgs = {
                {330, 80}
            }
        },
        {
            name = "...RUN!",
            startX = 50,
            startY = 40,
            goalX = 50,
            goalY = 200,
            enemiesClass = {
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankDummy,
                AITankHard
            },
            enemiesArgs = {
                {228, 60},
                {228, 90},
                {228, 120},
                {228, 150},
                {228, 180},
                {228, 210},
                {190, 60},
                {190, 90},
                {190, 120},
                {190, 150},
                {190, 180},
                {190, 210},
                {370, 120}
            }
        },
        {
            name = "The Gauntlet",
            startX = 50,
            startY = 120,
            goalX = 370,
            goalY = 120,
            enemiesClass = {
                AITankMedium,
                AITankEasy,
                AITankEasy,
                AITankEasy
            },
            enemiesArgs = {
                {350, 120},
                {228, 30},
                {300, 210},
                {100, 45}
            }
        }
    }
}