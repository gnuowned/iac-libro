# Sources from the asciidoc
SOURCES=$(wildcard *.adoc)
MAIN_ADOC=IaC-libro.adoc
OUT_HTML=html/IaC-libro.html
OUT_PDF=pdf/IaC-libro.pdf
OUT_EPUB=epub/IaC-libro.epub

# ASCIIDOC Container Image
ACI=asciidoctor/docker-asciidoctor

all: html pdf epub


.PHONY: html
html: $(SOURCES)
	asciidoctor --doctype book -o $(OUT_HTML) $(MAIN_ADOC)

.PHONY: pdf
pdf: $(SOURCES)
	asciidoctor-pdf --doctype book -o $(OUT_PDF) $(MAIN_ADOC)

.PHONY: epub
epub: $(SOURCES)
	asciidoctor-epub3 --doctype book -o $(OUT_EPUB) $(MAIN_ADOC)

podman:
	podman run --rm -i -v ${PWD}:/documents/:Z ${ACI} make

podman-html:
	podman run --rm -i -v ${PWD}:/documents/:Z ${ACI} make html

podman-pdf:
	podman run --rm -i -v ${PWD}:/documents/:Z ${ACI} make pdf

podman-epub:
	podman run --rm -i -v ${PWD}:/documents/:Z ${ACI} make epub

docker:
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v ${PWD}:/documents/ ${ACI} make

docker-html:
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v ${PWD}:/documents/ ${ACI} make html

docker-pdf:
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v ${PWD}:/documents/ ${ACI} make pdf

docker-epub:
	docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v ${PWD}:/documents/ ${ACI} make epub

fold: $(SOURCES)
	@echo "CUIDADO:"; \
	echo "         Este comando puede romper líneas de código de ejemplo";\
	echo "         mayores a 80 caracterses." ;\
	echo ;\
	echo "  Para salir oprima Control-C o enter para continuar"; \
	read teclado
	for file in $^ ; do \
		fold --spaces --width=80 $${file} > $${file}.tmp ; \
		mv $${file}.tmp  $${file}; \
		sed -i 's/[[:space:]]*$$//' $${file}; \
	done
