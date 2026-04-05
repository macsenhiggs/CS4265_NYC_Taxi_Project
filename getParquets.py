import asyncio
import httpx
from pathlib import Path

# --- Configuration ---
DEST_DIR = Path("downloads")
MAX_CONCURRENT_DOWNLOADS = 10 
#taxi_types = ["yellow", "green", "fhv", "fhvhv"] #for data analytics on all four types
taxi_types = ["yellow"] #scope restricted to yellow taxis for this project
years = range(2015, 2026) 
months = range(1, 13)

# --- URL Generation ---
URLS = []
for year in years:
    for month in months:
        m_str = f"{month:02d}"
        for t in taxi_types:
            # FHVHV only exists from 2/2019 onwards
            if t == "fhvhv" and (year < 2019 or (year == 2019 and month < 2)):
                continue
            
            url = f"https://d37ci6vzurychx.cloudfront.net/trip-data/{t}_tripdata_{year}-{m_str}.parquet"
            URLS.append(url)

print(f"Generated {len(URLS)} valid data URLs.")

# --- Download Logic ---
async def download_file(client, url):
    filename = url.split("/")[-1]
    save_path = DEST_DIR / filename
    
    if save_path.exists() and save_path.stat().st_size > 0:
        print(f"Skipping: {filename} (Already exists)")
        return

    try:
        async with client.stream("GET", url) as response:
            response.raise_for_status()

            temp_path = save_path.with_suffix(".tmp")
            
            with open(temp_path, "wb") as f:
                async for chunk in response.aiter_bytes():
                    f.write(chunk)
            
            temp_path.rename(save_path)
            print(f"Success: {filename}")
            
    except Exception as e:
        print(f"Failed: {filename} | Error: {e}")

async def main():
    DEST_DIR.mkdir(exist_ok=True)
    
    limits = httpx.Limits(max_connections=MAX_CONCURRENT_DOWNLOADS)
    
    async with httpx.AsyncClient(limits=limits, timeout=None) as client:
        tasks = [download_file(client, url) for url in URLS]
        await asyncio.gather(*tasks)

if __name__ == "__main__":
    asyncio.run(main())
