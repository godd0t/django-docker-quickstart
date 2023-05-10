from project_name.celery import app


@app.task(bind=True, name="test_periodic_task")
def test_periodic_task(self):  # noqa: Adding self since we are using bind=True
    print("Hello from periodic task")
