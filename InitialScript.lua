sendOSC({'/',
{
    { tag = 'i', value = 2 },       
    { tag = 'i', value = 0 }, 
    { tag = 's', value = 'Major' },
    { tag = 'f', value = 60 },  
    { tag = 'f', value = 62 }, 
    { tag = 'f', value = 64 }, 
    { tag = 'f', value = 65 }, 
    { tag = 'f', value = 67 }, 
    { tag = 'f', value = 69 }, 
    { tag = 'f', value = 71 }, 
    { tag = 'f', value = 72 }

}}, {true})

sendOSC({'/',
{
    { tag = 'i', value = 2 },       
    { tag = 'i', value = 0 }, 
    { tag = 's', value = 'Minor' },
    { tag = 'f', value = 60 },  
    { tag = 'f', value = 62 }, 
    { tag = 'f', value = 63 }, 
    { tag = 'f', value = 65 }, 
    { tag = 'f', value = 67 }, 
    { tag = 'f', value = 68 }, 
    { tag = 'f', value = 70 }, 
    { tag = 'f', value = 72 }

}}, {true})

sendOSC({'/',
{
    { tag = 'i', value = 2 },       
    { tag = 'i', value = 1 }, 
    { tag = 's', value = 'Major' },
    { tag = 'f', value = 60 },  
    { tag = 'f', value = 64 }, 
    { tag = 'f', value = 67 }

}}, {true})

sendOSC({'/',
{
    { tag = 'i', value = 2 },       
    { tag = 'i', value = 1 }, 
    { tag = 's', value = 'Minor' },
    { tag = 'f', value = 60 },  
    { tag = 'f', value = 63 }, 
    { tag = 'f', value = 67 }

}}, {true})

sendOSC({'/',
{
    { tag = 'i', value = 1 },       
    { tag = 'i', value = 0 }, 
    { tag = 's', value = 'Gb' },
    { tag = 's', value = 'Major' }

}}, {true})

sendOSC({'/',
{
    { tag = 'i', value = 1 },       
    { tag = 'i', value = 1 }, 
    { tag = 's', value = 'Db' },
    { tag = 's', value = 'Major' }

}}, {true})