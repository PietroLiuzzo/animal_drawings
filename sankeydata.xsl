<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="*:relation">
        <xsl:value-of select="@active"/><xsl:text>,</xsl:text><xsl:value-of select="@passive"/><xsl:text>,1</xsl:text>
    </xsl:template>
</xsl:stylesheet>