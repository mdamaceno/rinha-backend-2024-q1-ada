FROM fedora:39

RUN dnf install -y libpq gcc-gnat

WORKDIR /rinha

COPY ./bin/rinha_2024_q1_ada .

RUN useradd rinha --create-home --shell /bin/bash
RUN chown -R rinha:rinha /rinha

USER rinha:rinha

RUN chown rinha:rinha /rinha/rinha_2024_q1_ada

EXPOSE 9999

CMD ["./rinha_2024_q1_ada"]
