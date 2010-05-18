<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

  <xsl:output method='text' />

  <xsl:template match="/">
    <xsl:variable name="trackers" select="/document/trackers/tracker"/>
      <xsl:for-each select="$trackers">
<!--        Tracker #<xsl:value-of select="format-number(tracker_id, '0000000')" />:      <xsl:value-of select="name" />-->
          <xsl:variable name="groups" select="./groups/group" />
          <xsl:variable name="categories" select="./categories/category" />
          <xsl:variable name="resolutions" select="./resolutions/resolution" />
          <xsl:variable name="states" select="./statuses/status" />
          <xsl:variable name="items" select="./tracker_items/tracker_item" />
          <xsl:for-each select="//submitter">
            Submitter <xsl:value-of select="text()" />
          </xsl:for-each>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
