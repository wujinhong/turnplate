import flash.display.MovieClip;
public function stopAllChildren(m:MovieClip):void
{
	m.stop();
	var l:uint = m.numChildren;
	var c:*;
	while( --l >= 0 )
	{
		c = m.getChildAt(l);
		if (c is MovieClip)
		{
			stopAllChildren(c);
			c.stop();
		}
	}
}