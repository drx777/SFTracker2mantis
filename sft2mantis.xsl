<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date">

  <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

<!--
  https://sourceforge.net/apps/trac/sourceforge/wiki/XML%20export
  http://www.fedora-commons.org/confluence/display/~cwilper/2008/09/08/Sourceforge+Tracker+to+Jira+Migration
 -->

  <xsl:param name="CONFIG" select="document('config.xml')" />
  <xsl:param name="DEF_RESOLUTIONS" select="document('sft/resolutions.xml')" />
  <xsl:param name="DEF_VIEW_STATES" select="document('sft/view_states.xml')" />
  <xsl:param name="DEF_STATUSES" select="document('sft/statuses.xml')" />
  <xsl:param name="DEF_PRIORITIES" select="document('sft/priorities.xml')" />

  <xsl:template match="/">
    <xsl:variable name="trackers" select="/document/trackers/tracker"/>
    <mantis>
      <author>test</author>
      <date>2010-05-11 12:00</date>
      <xsl:for-each select="$trackers">
        <xsl:variable name="groups" select="./groups/group" />
        <xsl:variable name="categories" select="./categories/category" />
        <xsl:variable name="resolutions" select="./resolutions/resolution" />
        <xsl:variable name="states" select="./statuses/status" />
        <xsl:variable name="items" select="./tracker_items/tracker_item" />
        <xsl:for-each select="$items">
          <xsl:variable name="followUps" select="followups/followup" />
          <issue>
            <profile_id>1</profile_id>
            <project><xsl:value-of select="name" /></project>
            <reporter><xsl:value-of select="submitter" /></reporter>
            <handler><xsl:value-of select="assignee" /></handler>
            <priority>
              <xsl:variable name="priority" select="priority" />
              <xsl:attribute name="id">
                <xsl:value-of select="$DEF_PRIORITIES/priorities/priority[@id = $priority]/mantis/@id" />
              </xsl:attribute>
            </priority>
            <severity id="50" />
            <reproducibility id="100" />
            <status>
              <xsl:variable name="statusId" select="status_id" />
              <xsl:attribute name="id">
                <xsl:value-of select="$DEF_STATUSES/statuses/status[@id = $statusId]/mantis/@id" />
              </xsl:attribute>
            </status>
            <resolution>
              <xsl:variable name="resId" select="resolution_id" />
              <xsl:attribute name="id">
                <xsl:value-of select="$DEF_RESOLUTIONS/resolutions/resolution[@id = $resId]/mantis/@id" />
              </xsl:attribute>
            </resolution>
            <projection>none</projection>
            <category test="{category_id/text()}">
              <xsl:call-template name="getCategoryId">
                <xsl:with-param name="categories" select="$categories" />
                <xsl:with-param name="categoryId" select="category_id/text()" />
              </xsl:call-template>
              <xsl:if test="category_id/text() = 100">Other</xsl:if>
            </category>
            <date_submitted><xsl:value-of select="submit_date" /></date_submitted>
            <last_updated></last_updated>
            <eta id="10">none</eta>
            <view_state>
              <xsl:attribute name="id">
                <xsl:choose>
                  <xsl:when test="is_private = '0' or is_private = ''"><xsl:value-of
                    select="$DEF_VIEW_STATES/view-states/view-state[@id = 'private']" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$DEF_VIEW_STATES/view-states/view-state[@id = 'public']" /></xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </view_state>
            <summary><xsl:value-of select="summary" /></summary>
            <due_date>1</due_date>
            <description>
              <xsl:value-of select="details" />
              <xsl:if test="count($followUps) &gt; 0 and $CONFIG/config/setting[@id = 'append_comments']">

----------------------------
comments from SFT
----------------------------
                <xsl:for-each select="$followUps">
comment   #<xsl:value-of select="position()" />
date:     <xsl:call-template name="isodate"><xsl:with-param name="uts" select="date" /></xsl:call-template>
reporter: <xsl:value-of select="submitter" />
note:
<xsl:value-of select="details" />

----------------------------
                </xsl:for-each>
              </xsl:if>
            </description>
            <bugnotes>
              <xsl:for-each select="$followUps">
                <bugnote>
                  <id>0</id>
                  <reporter_username><xsl:value-of select="submitter" /></reporter_username>
                  <note><xsl:value-of select="details" /></note>
                  <view_state>
                    <xsl:attribute name="id">
                      <xsl:choose>
                        <xsl:when test="is_private != ''"><xsl:value-of select="$DEF_VIEW_STATES/view-states/view-state[@id = 'private']" /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$DEF_VIEW_STATES/view-states/view-state[@id = 'public']" /></xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </view_state>
                  <date_submitted><xsl:value-of select="date" /></date_submitted>
                  <last_modified></last_modified>
                </bugnote>
              </xsl:for-each>
            </bugnotes>
          </issue>
        </xsl:for-each>
      </xsl:for-each>
    </mantis>
  </xsl:template>

  <xsl:template name="getCategoryId">
    <xsl:param name="categories" />
    <xsl:param name="categoryId" />

    <xsl:for-each select="$categories">
      <xsl:if test="id = $categoryId">
        <xsl:value-of select="category_name" />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="isodate">
    <xsl:param name="uts" />
    <xsl:value-of select="date:add('1970-01-01T00:00:00Z', date:duration($uts))"/>
  </xsl:template>

</xsl:stylesheet>
