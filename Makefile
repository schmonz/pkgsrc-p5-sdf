# $NetBSD: Makefile,v 1.11 2024/11/16 12:07:15 wiz Exp $

DISTNAME=	sdf-2.001
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	5
CATEGORIES=	textproc perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=../../authors/id/I/IA/IANC/}

MAINTAINER=	schmonz@NetBSD.org
HOMEPAGE=	https://metacpan.org/release/sdf
COMMENT=	Simple Document Format to generate multiple output formats
LICENSE=	2-clause-bsd

PERL5_PACKLIST=	auto/SDF/.packlist
USE_LANGUAGES=	# none

SUBST_CLASSES=		pkgsep
SUBST_STAGE.pkgsep=	post-configure
SUBST_FILES.pkgsep=	bin/sdfget bin/sdf \
			perllib/sdf/home/stdlib/misc.sdm \
			perllib/sdf/home/stdlib/bugtrack.sdm \
			perllib/sdf/home/stdlib/mif.sdn \
			perllib/sdf/home/stdlib/usecases.sdm \
			perllib/sdf/home/stdlib/delphi.sdm \
			perllib/sdf/values.pl \
			perllib/sdf/tohtml.pl \
			perllib/sdf/subs.pl \
			perllib/sdf/tomif.pl \
			perllib/sdf/calc.pl \
			perllib/sdf/name.pl \
			perllib/sdf/macros.pl \
			perllib/sdf/parse.pl \
			perllib/sdf/filters.pl \
			doc/guru/ex_filt.sdf \
			doc/ref/sfindfil.sdf
SUBST_SED.pkgsep=	-e "s| &'| ::|g"
SUBST_SED.pkgsep+=	-e "s|	&'| ::|g"
SUBST_SED.pkgsep+=	-e "s|(&'|(::|g"
SUBST_SED.pkgsep+=	-e "s|\!&'|!::|g"

pre-configure:
	${FIND} ${WRKSRC} -type f -name '*.orig' -print | ${XARGS} ${RM} -f

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
