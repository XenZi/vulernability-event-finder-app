
import asyncio


class ManagedQueue:
    def __init__(self) -> None:
        self.queue = asyncio.Queue()

    async def add(self, item):
        await self.queue.put(item)
        print(f'Queue size: {self.queue.qsize()}')

    async def get(self):
        item = await self.queue.get()
        return item
    
    def task_done(self):
        self.queue.task_done()

    async def wait_until_empty(self):
        await self.queue.join()


