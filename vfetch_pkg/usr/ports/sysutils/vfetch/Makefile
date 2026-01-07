# $FreeBSD$

PORTNAME=	vfetch
PORTVERSION=	1.0.0
CATEGORIES=	sysutils

MAINTAINER=	xaturing@example.com
COMMENT=	V-Nim FastFetch-like system information tool
WWW=		https://github.com/xaturing/vfetch

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

NO_BUILD=	yes
NO_ARCH=	yes

do-install:
	${INSTALL_PROGRAM} ${WRKDIR}/usr/local/bin/vfetch ${STAGEDIR}${PREFIX}/bin/vfetch

.include <bsd.port.mk>