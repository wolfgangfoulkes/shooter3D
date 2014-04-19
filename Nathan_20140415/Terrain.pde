class Ground
{
  Terrain pt;
  Ground (PApplet pa)
  {
    terrain = new Terrain(pa, gridSlices, terrainSize, horizon);
    terrain.usePerlinNoiseMap(-70, 70, 2.125f, 2.125f);
    terrain.drawMode(S3D.TEXTURE);
    terrain.tagNo = -1;
    terrain.tag = "Ground";
    /*
    terrain.setTexture(terrainTex[(int)random(0, terrainTex.length)], 16);
    */
  }
}
