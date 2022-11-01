from utilities.get_user import create_url_user, get_user_details 
from utilities.get_tweets_by_user import create_url_tweets, get_user_tweets
from auth.auth import BearerTokenAuth
from database.postgres import create_pg_engine
import boto3
import yaml
import pandas as pd
import logging
import json




def main():

    with open('./pipeline/config.yaml', 'r') as file:
        config = yaml.safe_load(file)

    # s3 bucket 
    s3 = boto3.resource('s3')
    bucket_name = 'decbrismoh-snowflake'
    folder = 'dec-project-2'

    
    # set up logging
    logging.basicConfig(level=logging.INFO, format="[%(levelname)s][%(asctime)s]: %(message)s")


    # Twitter handles of data influencers
    with open('user_data/users.txt', 'r') as file:

        user_handles = file.readlines()
        cleaned_handles = [user.split('.com/')[-1].strip().replace('/','') for user in user_handles]


    # postgres engine
    engine = create_pg_engine()

    for user in cleaned_handles:

        logging.info(f'Getting tweets for {user}')
        
        user_url = create_url_user(user_name=user)
        user_id = get_user_details(user_url).get('data')[0].get('id')

        tweet_url = create_url_tweets(user_id)

        # get some tweets
        tweets = get_user_tweets(tweet_url, params=config)

        if tweets.get('meta').get('result_count') == 0:
            logging.info(f'{user} has no tweets between {config.get("start_time")} and {config.get("end_time")}')
            continue


        # Save records
        try:
            s3object = s3.Object(bucket_name, f'{folder}/{user}.json')
            s3object.put(
                Body=(bytes(json.dumps(tweets).encode('UTF-8')))
            )
            logging.info(f'Successfully saved tweets for user: {user} at {bucket_name}')

        
        except BaseException as err:
            logging.exception(err)
            return None


        # Get more tweets if possible
        while True:

            if tweets.get('meta').get('next_token'):

                config['pagination_token'] = tweets.get('meta').get('next_token')
                tweets = get_user_tweets(tweet_url, params=config)

                # Save records
                try:
                    s3object = s3.Object(bucket_name, f'{folder}/{user}-{config.get("pagination_token")[:3]}.json')
                    s3object.put(
                        Body=(bytes(json.dumps(tweets).encode('utf-8')))
                    )
                
                except BaseException as err:
                    logging.exception(err)
                    return None

                logging.info(f'Successfully saved tweets from next page for user: {user} at {bucket_name}')
                continue 

            break

        
    return True



if __name__ == '__main__':

    if main():
        logging.info("Successfully saved tweets for data influencers")
    else:
        logging.debug("An error seems to have occurred")
        
