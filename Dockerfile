FROM python:3.9-buster AS build
ARG VERSION
WORKDIR /app
RUN pip install poetry && poetry config virtualenvs.create false
COPY pyproject.toml poetry.lock ./
RUN poetry install
COPY app ./app
RUN poetry build

FROM python:3.9-buster
ARG VERSION
RUN pip install waitress==2.0.0
COPY --from=build /app/dist/app-${VERSION}-py3-none-any.whl .
RUN pip install ./app-${VERSION}-py3-none-any.whl

CMD [ "waitress-serve", "--call", "app.app:create_app" ]
